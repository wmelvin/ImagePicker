unit uPicksFile;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ComCtrls, Dialogs, ExtCtrls, StdCtrls;

procedure SavePicksFile(FileName: String; TitleText: String; Picks: TListBox; StatusBar: TStatusBar);

function LoadPicksFile(OpenDialog: TOpenDialog; editTitle: TLabeledEdit; Picks: TListBox; StatusBar: TStatusBar): String;


implementation

uses uApp, uImageInfo, StrUtils;

procedure SavePicksFile(FileName: String; TitleText: String; Picks: TListBox; StatusBar: TStatusBar);
var
  tf: TextFile;
  i: Integer;
  item: TImageInfo;
  n: Integer;
  pad_tagged: Integer;
  pad_all: Integer;
  title: String;
begin
  StatusBar.SimpleText := 'Save as ' + FileName;
  AssignFile(tf, FileName);
  try
    rewrite(tf);

    writeln(tf, '# Created ' + FormatDateTime('yyyy-mm-dd_hh:nn:ss', Now)
      + ' by ' + APP_TITLE);

    // Write title.
    title := Trim(TitleText);
    writeln(tf, '# Title: ' + title);
    writeln(tf, '');
    writeln(tf, '');

    // Write file paths.
    for i := 0 to Picks.Items.Count - 1 do
    begin
      item := TImageInfo(Picks.Items.Objects[i]);
      writeln(tf, '"' + item.FullName + '"');
    end;

    // Get length of longest file name in items with a tag.
    pad_tagged := 0;
    pad_all := 0;
    for i := 0 to Picks.Items.Count - 1 do
    begin
      item := TImageInfo(Picks.Items.Objects[i]);
      n := Length(item.GetFileName);
      if pad_all < n then
        pad_all := n;
      if item.HasTag then
        if pad_tagged < n then
          pad_tagged := n;
    end;

    if 0 < pad_tagged then
      // There are one or more items with a tag.
      begin
        writeln(tf, '');
        writeln(tf, '');
        writeln(tf, '## -- Tagged Images:');
        for i := 0 to Picks.Items.Count - 1 do
        begin
          item := TImageInfo(Picks.Items.Objects[i]);
          if item.HasTag then
            writeln(tf,
              '# Tag: "' + item.Tag + '", "' + item.GetFileName + '"'
            );
        end;

        writeln(tf, '');
        writeln(tf, '');
        writeln(tf, '## -- Move/rename tagged files (original):');
        for i := 0 to Picks.Items.Count - 1 do
        begin
          item := TImageInfo(Picks.Items.Objects[i]);
          if item.HasTag then
            writeln(tf, '# ' + item.AsMvCmd(pad_tagged));
        end;

      end;

    if Length(title) = 0 then
      // Set default title for use by AsMvCmd.
      title := 'image';

    writeln(tf, '');
    writeln(tf, '');
    writeln(tf, '## -- Move/rename all files (new name):');
    for i := 0 to Picks.Items.Count - 1 do
    begin
      item := TImageInfo(Picks.Items.Objects[i]);
      writeln(tf, '# ' + item.AsMvCmd(pad_all, title, i));
    end;

    CloseFile(tf);
  except
    on E: EInOutError do
      StatusBar.SimpleText := 'ERROR: ' + E.Message;
  end;
end;

function LoadPicksFile(OpenDialog: TOpenDialog; editTitle: TLabeledEdit; Picks: TListBox; StatusBar: TStatusBar): String;
var
  tf: TextFile;
  fn: String;
  s: String;
  title: String;
  paths_list: TStringList;
  tags_list: TStringList;
  err_list: TStringList;
  i: Integer;
  info: TImageInfo;
  tag_nv: String;
  tag_val: String;
  first_line: Boolean;
  ok: Boolean;

  {local} function ParsedTag(const TagStr: String; VAR TagNameValue: String): Boolean;
  var
    fn: String;
    tg: String;
  begin
    ParsedTag := False;
    if not (LeftStr(TagStr, 6) = '# Tag:') then
      Exit;
    fn := Trim(RightStr(s, Length(s) - 6));
    tg := Trim(Copy2SymbDel(fn, ','));
    fn := Trim(fn);
    if (0 < Length(fn)) and (0 < Length(tg)) then
      begin
        TagNameValue := fn + '=' + tg;
        ParsedTag := True;
      end;
  end;

begin
  LoadPicksFile := '';
  OpenDialog.Filter := 'Text files (*.txt)|*.txt;*.TXT';
  if OpenDialog.Execute then
    begin
      fn := OpenDialog.FileName;
      paths_list := TStringList.Create;
      tags_list := TStringList.Create;
      err_list := TStringList.Create;
      title := '';
      tag_nv := '';
      try
        AssignFile(tf, fn);
        try
          Reset(tf);
          first_line := True;
          ok := True;
          while ok and (not EOF(tf)) do
          begin
            ReadLn(tf, s);

            if first_line then
              begin
                first_line := False;
                if not ((LeftStr(s, 1) = '#')
                and (0 < Pos('ImagePicker', s))) then
                  begin
                    MessageDlg(
                      'Cannot Load',
                      'File does not match ImagePicker format.',
                      mtWarning, [mbClose],0);
                    ok := False;
                    continue;
                  end;
              end;

            s := Trim(s);

            if (0 < Length(s)) and (LeftStr(s, 1) <> '#') then
              paths_list.Add(TrimSet(s, ['"']))
            else if ParsedTag(s, tag_nv) then
              tags_list.Add(tag_nv)
            else if LeftStr(s, 8) = '# Title:' then
              title := Trim(RightStr(s, Length(s) - 8));
          end;
        finally
          CloseFile(tf);
        end;
      except
        on E: EInOutError do
          StatusBar.SimpleText := 'ERROR: ' + E.Message;
      end;

      if 0 < paths_list.Count then
      begin
        editTitle.Text := title;
        Picks.Clear;
        for i := 0 to paths_list.Count -1 do
        begin
          if FileExists(paths_list[i]) then
            begin
              // Return the last valid file path.
              LoadPicksFile := paths_list[i];

              info := TImageInfo.Create(paths_list[i], '');

              // Names and values in tags_list are in double quotes.
              tag_val := tags_list.Values['"' + info.GetFileName + '"'];
              if (0 < Length(tag_val)) then
                info.Tag := TrimSet(tag_val, ['"']);

              Picks.Items.AddObject(info.GetFileName, info);
            end
          else
            err_list.Add('NOT FOUND: ' + paths_list[i]);
        end;
      end;
      if 0 < err_list.Count then
        MessageDlg('ERRORS', err_list.GetText, mtError, [mbOk], 0);
    end;
end;

end.

