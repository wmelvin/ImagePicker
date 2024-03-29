# Developer Notes for ImagePicker project

## Initial Plan

The image below is a scan of the notepad page with the initial plan for the application.

![Scanned notepad page with initial plan for the ImagePicker application](readme_images/initial-plan-notepad-page.jpg)

It did not turn out exactly as envisioned. A software project always evolves as you build it, especially when it gets to the point where you can start using it.

## Notes

### IDE Macros

In project options, what are settings like `$(ProjOutDir)`?

Doc: [IDE Macros in paths and filenames](https://wiki.freepascal.org/IDE_Macros_in_paths_and_filenames)

### Unit not found error

Error when clicking on an Event in the Object Inspector (wanting to add an OnCreate event handler):

**"Error: unit not found ExtCtrls"**

Fixed:

`Tools` / `Options` / `Files` / `FPC source directory`:

Changed from
`/usr/share/fpcsrc/$(FPCVER)`
to
`/usr/share/fpcsrc/3.2.2`

The 'unit not found' error went away. Changed back to the original setting. The error did not come back. Hmmm...

### GLIBC version issue

When attempting to run the compiled Linux executable on an older version of Ubuntu (18.04) the application failed to start. It showed the following error message:

```console
./ImagePicker: /lib/x86_64-linux-gnu/libc.so.6: version `GLIBC_2.34' not found (required by ./ImagePicker)
```

Use `ldd` to see the version of GLIBC.

```console
$ ldd --version
ldd (Ubuntu GLIBC 2.27-3ubuntu1.6) 2.27
```

What is the version on the machine where the project is being built?

```console
$ ldd --version
ldd (Ubuntu GLIBC 2.35-0ubuntu3.1) 2.35
```

Lazarus forum:

- [/lib/x86_64-linux-gnu/libc.so.6: version GLIBC_2.34; not found](https://forum.lazarus.freepascal.org/index.php?topic=58888.30)
- [/lib/x86_64-linux-gnu/libc.so.6: version GLIBC_2.34; not found](https://forum.lazarus.freepascal.org/index.php?topic=58888.0)


Stack Overflow: [glibc - Is there anyway to include libc.so in a Lazarus/Free pascal compiled binary?](https://stackoverflow.com/questions/45896280/is-there-anyway-to-include-libc-so-in-a-lazarus-free-pascal-compiled-binary) (the answer was *no*)

> Your best bet is to build on the oldest OS you plan to support...

Built the ImagePicker project on Xubuntu 18.04 and the compiled executable also worked on newer Ubuntu versions.

---

## Links and Commits

[Lazarus Homepage](https://www.lazarus-ide.org/)

Lazarus [gitignore](https://github.com/github/gitignore/blob/main/Global/Lazarus.gitignore)

- [x] **Initial commit. New project.**
<sup>Commit [a4d571f](https://github.com/wmelvin/ImagePicker/commit/a4d571fd48eaedfd1fd0533299fd028498b4a62d) (2023-03-07 06:57:34)</sup>

---

Docs: [TMainMenu](https://wiki.lazarus.freepascal.org/TMainMenu), [TPanel](https://wiki.lazarus.freepascal.org/TPanel), [TStatusBar](https://lazarus-ccr.sourceforge.io/docs/lcl/comctrls/tstatusbar.html)

- [x] **Add initial components.**
<sup>Commit [3bf104d](https://github.com/wmelvin/ImagePicker/commit/3bf104de6c89bbaf05b25410a09a7d4c1ea24560) (2023-03-08 07:15:18)</sup>

---

Docs: [TSplitter](https://wiki.lazarus.freepascal.org/TSplitter)

- [x] **Set properties. Add toggle button.**
<sup>Commit [9039e1d](https://github.com/wmelvin/ImagePicker/commit/9039e1dfbd1ca628699cab72daba9420c931e36e) (2023-03-08 07:31:58)</sup>

---

Are there open source icons available to use for buttons?

- [Glyphs](https://glyphs.fyi/) - The Complete Icon Design System
- [glyphs.fyi - Directory](https://glyphs.fyi/dir?c=multimedia&amp;i=play&amp;v=bold&amp;w)

Docs: [TImage](https://wiki.lazarus.freepascal.org/TImage)

How to scale image in TImage component? Properties:

```pascal
    Center := True;
    Proportional := True;
    Stretch := True;
```

Docs: [Howto Use TOpenDialog](https://wiki.lazarus.freepascal.org/Howto_Use_TOpenDialog)

- [x] **Add images for button.**
<sup>Commit [e5d4bf3](https://github.com/wmelvin/ImagePicker/commit/e5d4bf315a2c3e57cd8b54119dc89c86bb50dd34) (2023-03-08 09:35:44)</sup>

- [x] **Add image component, and file dialogs.**
<sup>Commit [def69e4](https://github.com/wmelvin/ImagePicker/commit/def69e4febd7e8f79f851401c67286298c6f8833) (2023-03-08 15:25:55)</sup>

- [x] **Add more images for buttons.**
<sup>Commit [fe158cb](https://github.com/wmelvin/ImagePicker/commit/fe158cbfed46e90f64c7a86fb38ecf7a63202d07) (2023-03-08 15:45:18)</sup>

- [x] **Add buttons and glyphs.**
<sup>Commit [ad932e6](https://github.com/wmelvin/ImagePicker/commit/ad932e6790045c221b8373e2275fc05b2e780fdf) (2023-03-08 16:27:09)</sup>

---

Docs: [TStringList](https://lazarus-ccr.sourceforge.io/docs/rtl/classes/tstringlist.html), [TStringList-TStrings Tutorial](https://wiki.lazarus.freepascal.org/TStringList-TStrings_Tutorial)

- [x] **Units for image viewing functions.**
<sup>Commit [009f815](https://github.com/wmelvin/ImagePicker/commit/009f815543e9305c9b240d9703b8af22dd4c074d) (2023-03-08 16:51:07)</sup>

---

Docs: [TTimer](https://wiki.freepascal.org/TTimer)

- [x] **Implement slideshow using default dir.**
<sup>Commit [c7b6cc6](https://github.com/wmelvin/ImagePicker/commit/c7b6cc67c11fab4ff66540841dc34fce7fa71f91) (2023-03-08 17:59:26)</sup>

- [x] **Change button layout.**
<sup>Commit [3a51089](https://github.com/wmelvin/ImagePicker/commit/3a51089c23a47c1fa2c5c06c369e1d1bfb709e19) (2023-03-08 18:06:34)</sup>

---

Docs: [key down](https://wiki.lazarus.freepascal.org/key_down), [LCL Key Handling](https://wiki.lazarus.freepascal.org/LCL_Key_Handling), [virtual keyboard strokes/de](https://wiki.freepascal.org/virtual_keyboard_strokes/de)

- [x] **Add keyboard commands.**
<sup>Commit [81e8398](https://github.com/wmelvin/ImagePicker/commit/81e8398861c97601d450c450664684af47c84d7c) (2023-03-08 19:31:40)</sup>

---

Docs: [TListBox](https://wiki.lazarus.freepascal.org/TListBox)

- [x] **Add list of selected images.**
<sup>Commit [57933e5](https://github.com/wmelvin/ImagePicker/commit/57933e5782334a61f45f16458b7c1ce46b23f2b6) (2023-03-08 21:37:27)</sup>

---

- [x] **Implement File/Open.**
<sup>Commit [1a3568d](https://github.com/wmelvin/ImagePicker/commit/1a3568d9bf881f57d6dd3c813b3a6c21b45d6b82) (2023-03-09 07:29:29)</sup>

- [x] **Clear Panel1.Caption when image loaded.**
<sup>Commit [cdf464c](https://github.com/wmelvin/ImagePicker/commit/cdf464c6e0f833484078e10c926c1a6de01f65df) (2023-03-09 08:11:08)</sup>

- [x] **Include arrow keys for navigation.**
<sup>Commit [0bc415a](https://github.com/wmelvin/ImagePicker/commit/0bc415a1677e3632c07d8bd20a4065ea77db549c) (2023-03-09 08:16:54)</sup>

- [x] **Delete from selected images list.**
<sup>Commit [51c2af2](https://github.com/wmelvin/ImagePicker/commit/51c2af269e87740a586eb856e05dbc879b0d0d30) (2023-03-09 08:24:36)</sup>

---

Had trouble figuring out how to get command-line args.

Docs: [Command line parameters and environment variables](https://wiki.lazarus.freepascal.org/Command_line_parameters_and_environment_variables)

In the IDE, used `Run` / `Run Parameters` / `Command line parameters` to pass the path to the `Pictures` dir.

Docs: [IDE Window: Run parameters](https://wiki.freepascal.org/IDE_Window:_Run_parameters)

Using [ParamCount](https://www.freepascal.org/docs-html/rtl/system/paramcount.html) and [ParamStr](https://www.freepascal.org/docs-html/rtl/system/paramstr.html) does not work in a Lazarus application. It seems the Application object gets the parameters and then (maybe) clears them from the original ParamStr.

Docs: [TCustomApplication](https://www.freepascal.org/docs-html/fcl/custapp/tcustomapplication.html)

The parameters are available via `GetNonOptions`. I messed up at first, thinking the first parameter was still the name of the executable (like `ParamStr(0)`). That is not the case. The first item in the list is the first parameter.

Docs: [TCustomApplication.GetNonOptions](https://lazarus-ccr.sourceforge.io/docs/fcl/custapp/tcustomapplication.getnonoptions.html)

- [x] **Take command-line argument.**
<sup>Commit [ea18552](https://github.com/wmelvin/ImagePicker/commit/ea1855278f021b8a5b1ab9b65cdd24ac4e5c3ca8) (2023-03-09 10:01:14)</sup>

---

Save the list of picked images to a text file. The format of the text file includes the list of the full path to each image file, and a section with `mv` commands to rename the files based on *Title* and *Tag*. At this point, the idea is to provide commands that can be copied into a separate script for whatever task is to be done with the current set of image files.

- [x] **Implement File/Save.**
<sup>Commit [0ced44b](https://github.com/wmelvin/ImagePicker/commit/0ced44b3563788f214b298035acbcd34f73a7443) (2023-03-09 14:03:44)</sup>

- [x] **Enter Tag for selected images.**
<sup>Commit [412ba2a](https://github.com/wmelvin/ImagePicker/commit/412ba2adff0d902a5df2bbfd938bfe75dbdbbb17) (2023-03-09 14:59:45)</sup>

- [x] **Arrow keys navigation conditional.**
<sup>Commit [abdf356](https://github.com/wmelvin/ImagePicker/commit/abdf35627edc0c804ea70dfba41db92b80cc2c7e) (2023-03-09 16:49:21)</sup>

- [x] **Improve arrow key handling.**
<sup>Commit [fe9e732](https://github.com/wmelvin/ImagePicker/commit/fe9e732fc94fbfa5f4e1c7d25699ca603ded4a5e) (2023-03-09 17:22:53)</sup>

- [x] **Add title to output file name.**
<sup>Commit [1ab770f](https://github.com/wmelvin/ImagePicker/commit/1ab770fdb04288c0fa5ee427afe3d391cdd89aaa) (2023-03-09 18:05:32)</sup>

- [x] **Add hints re hotkeys to buttons.**
<sup>Commit [d42c405](https://github.com/wmelvin/ImagePicker/commit/d42c405c07e2b583687ec72fd4c4e1e3c71a85ab) (2023-03-09 19:49:07)</sup>

- [x] **Add title and tags section to output.**
<sup>Commit [4afb6da](https://github.com/wmelvin/ImagePicker/commit/4afb6da871ae13284de39acea0ea444186365987) (2023-03-10 07:38:38)</sup>

---

- [x] **Show image for selected item in list.**
<sup>Commit [a737c07](https://github.com/wmelvin/ImagePicker/commit/a737c07338259d0c2ee80d22c496c104c3d4a9ef) (2023-03-10 08:37:23)</sup>

---

Confirm remove from list with Yes/No `MessageDlg`.

Docs: [Dialog Examples](https://wiki.lazarus.freepascal.org/Dialog_Examples)

- [x] **Change Delete to Remove. No dups in lists.**
<sup>Commit [c98e3d1](https://github.com/wmelvin/ImagePicker/commit/c98e3d178d5fd77c889a941fcfd1e3d637b17160) (2023-03-10 09:38:40)</sup>

- [x] **Also show tag in status bar.**
<sup>Commit [3e4406d](https://github.com/wmelvin/ImagePicker/commit/3e4406db19e28ce55fac0e865c96d4d7ef24abb8) (2023-03-10 09:53:51)</sup>

- [x] **Anchor buttons below list box.**
<sup>Commit [146d6ad](https://github.com/wmelvin/ImagePicker/commit/146d6ad386f16d21780db11428c03ced383be407) (2023-03-10 10:33:30)</sup>

---

Add a TrackBar for navigation in large sets of images.

Docs: [TTrackBar](https://wiki.lazarus.freepascal.org/TTrackBar)

- [x] **Add TrackBar for browsing images.**
<sup>Commit [47517b5](https://github.com/wmelvin/ImagePicker/commit/47517b5f6aa1d1606830616f17e1ca403ac328a4) (2023-03-10 14:40:33)</sup>

---

Any settings that can improve image quality? Turning on anti-aliasing did help.

- [x] **Set AntialiasingMode = amOn.**
<sup>Commit [5e56e97](https://github.com/wmelvin/ImagePicker/commit/5e56e975301838ed1d1e8055e55237128b7ab752) (2023-03-10 14:51:24)</sup>

---

No need for Splitter. Toggling Panel2 in and out is good enough.

- [x] **Change panel layout to fix toggle.**
<sup>Commit [7c6be41](https://github.com/wmelvin/ImagePicker/commit/7c6be415ecab5df0e7e7214a642c3d0f055abf04) (2023-03-10 17:14:33)</sup>

---

Docs: [Copy2SymbDel](https://lazarus-ccr.sourceforge.io/docs/rtl/strutils/copy2symbdel.html), [TrimSet](https://lazarus-ccr.sourceforge.io/docs/rtl/strutils/trimset.html), [TStrings.Values](https://lazarus-ccr.sourceforge.io/docs/rtl/classes/tstrings.values.html)

- [x] **Load from previous output file (initial).**
<sup>Commit [15cdfcf](https://github.com/wmelvin/ImagePicker/commit/15cdfcf7332f63e0532da403c362c06b62f291d0) (2023-03-10 18:49:06)</sup>

- [x] **Load from previous output file.**
<sup>Commit [0173b7c](https://github.com/wmelvin/ImagePicker/commit/0173b7c99e6709cec19831860c94d979621e35ca) (2023-03-11 07:47:14)</sup>

- [x] **Create initial README.md and devnotes.md.**
<sup>Commit [226a02b](https://github.com/wmelvin/ImagePicker/commit/226a02be0e25b7c4e4829ae625266ff736e909e2) (2023-03-11 09:12:14)</sup>

- [x] **Refactor load from file so TrackBar is updated.**
<sup>Commit [3f98043](https://github.com/wmelvin/ImagePicker/commit/3f980437a4b994212043c232b50c4b2ceeac8bd3) (2023-03-11 10:12:59)</sup>

- [x] **Add rename-all section to output.**
<sup>Commit [8762560](https://github.com/wmelvin/ImagePicker/commit/8762560da276ac0342dd85d3cd1fb88e102ad963) (2023-03-11 14:57:13)</sup>

---

Docs (Multiplatform Programming Guide): [Configuration files](https://wiki.lazarus.freepascal.org/Multiplatform_Programming_Guide#Configuration_files), [Data and Resource files](https://wiki.lazarus.freepascal.org/Multiplatform_Programming_Guide#Data_and_resource_files)

- [x] **Add Tools/Options menu (initial).**
<sup>Commit [a0178d3](https://github.com/wmelvin/ImagePicker/commit/a0178d336fac4c7637f9f84293cc6755e967f1c6) (2023-03-12 15:57:17)</sup>

- [x] **Update APP_VERSION.**
<sup>Commit [d5c51cf](https://github.com/wmelvin/ImagePicker/commit/d5c51cf62d59985ec8c8c8eeb3780fdf49c0d526) (2023-03-12 17:13:33)</sup>

- [x] **Add uapp.pas for const such as APP_VERSION.**
<sup>Commit [057a4fb](https://github.com/wmelvin/ImagePicker/commit/057a4fbdcb25f942e2f082250fabfdf330d5c7e7) (2023-03-13 11:05:20)</sup>

---

Docs: [TListBox](https://wiki.lazarus.freepascal.org/TListBox), [TStrings.Exchange](https://lazarus-ccr.sourceforge.io/docs/rtl/classes/tstrings.exchange.html)

- [x] **Add buttons to show and move ListBox items.**
<sup>Commit [dbf83a6](https://github.com/wmelvin/ImagePicker/commit/dbf83a611a523460915f5e70cb48f7d4e438e5f8) (2023-03-13 12:05:46)</sup>

- [x] **Handle show and move ListBox items.**
<sup>Commit [4532cd6](https://github.com/wmelvin/ImagePicker/commit/4532cd678a24f5b3603a86ae206359a110bd203a) (2023-03-13 14:47:12)</sup>

- [x] **Sort on File/Open. Check first line on File/Load.**
<sup>Commit [3c58dbe](https://github.com/wmelvin/ImagePicker/commit/3c58dbe365b708146a913589458b18cc6740a8f0) (2023-03-13 18:17:34)</sup>

---

- [x] **Work on arrow key behavior.**
<sup>Commit [fb56d94](https://github.com/wmelvin/ImagePicker/commit/fb56d94685d29dad0c0be4143cb827d3401c17da) (2023-03-14 10:01:10)</sup>

---

Without the speed control, Panel3 can be more narrow. Put the buttons in one column.

- [x] **Move speed control. Nav buttons in one column.**
<sup>Commit [fc3b85c](https://github.com/wmelvin/ImagePicker/commit/fc3b85cb33307671d9f535c60d4f3fa0f927dd8e) (2023-03-15 21:14:08)</sup>

- [x] **Update tab order.**
<sup>Commit [5d6c0ea](https://github.com/wmelvin/ImagePicker/commit/5d6c0ea0611df473140e71d569e1a1ee0de4bf50) (2023-03-15 21:17:48)</sup>

- [x] **Click on image to show full path in status bar.**
<sup>Commit [e6a6deb](https://github.com/wmelvin/ImagePicker/commit/e6a6deb23be291606fc0f780dfa5188e96dbd002) (2023-03-15 21:26:28)</sup>

---

- [x] **Use last image to LoadImagesList in LoadFromSavedFile**
<sup>Commit [8f9b99b](https://github.com/wmelvin/ImagePicker/commit/8f9b99bbde2f626cb362daa71a24f0dd8bdb8364) (2023-03-15 21:33:27)</sup>

- [x] **Spacebar play/stop when not in edit control**
<sup>Commit [1a98c48](https://github.com/wmelvin/ImagePicker/commit/1a98c480674515f7b5afd8705cfc7b6ccc620316) (2023-03-15 21:47:30)</sup>

- [x] **Swap F6 and F7 show selected images functions**
<sup>Commit [427dbdf](https://github.com/wmelvin/ImagePicker/commit/427dbdf73924d68299b7133dc9c4db6cfc6b5ab4) (2023-03-15 22:09:00)</sup>

---

Docs: [GetAppConfigDir](https://lazarus-ccr.sourceforge.io/docs/rtl/sysutils/getappconfigdir.html)

- [x] **Add TAppOptions class.**
<sup>Commit [095f1b7](https://github.com/wmelvin/ImagePicker/commit/095f1b7c38113af9ae340e9c267e04da6a69ab37) (2023-03-17 19:16:30)</sup>

- [x] **Implement LastOpenDir and LastSaveDir for TAppOptions.**
<sup>Commit [83a1905](https://github.com/wmelvin/ImagePicker/commit/83a19052b5224c32cc3de59bff61b701e0b8fc12) (2023-03-17 20:30:43)</sup>

---

Add methods to actually copy the selected files in the ListBox.

Docs: [TSelectDirectoryDialog](https://wiki.lazarus.freepascal.org/TSelectDirectoryDialog), [TSelectDirectoryDialog](https://lazarus-ccr.sourceforge.io/docs/lcl/dialogs/tselectdirectorydialog.html), [CopyFile](https://wiki.lazarus.freepascal.org/CopyFile)

- [x] **New form saved as uCopyFilesDlg.**
<sup>Commit [cca565f](https://github.com/wmelvin/ImagePicker/commit/cca565f4c66f1d7f1ba66af5342a285bd4787993) (2023-03-18 07:34:49)</sup>

- [x] **Add new form files.**
<sup>Commit [4517c9a](https://github.com/wmelvin/ImagePicker/commit/4517c9aa3a96524378a4ef7e60e98b0713f1f95e) (2023-03-18 08:06:24)</sup>

- [x] **CopyFilesDlg initial components and properties**
<sup>Commit [d9d5e32](https://github.com/wmelvin/ImagePicker/commit/d9d5e329b6a759ae72f98e1d444f7f51d2cbc584) (2023-03-18 08:35:16)</sup>

- [x] **CopyFilesDlg browse for folder**
<sup>Commit [aba8255](https://github.com/wmelvin/ImagePicker/commit/aba8255d1ca1d3d3175c1ea81b8d5772d4041859) (2023-03-18 09:16:11)</sup>

- [x] **Add method CopyFilesInList**
<sup>Commit [289ddc4](https://github.com/wmelvin/ImagePicker/commit/289ddc4fc5ae7cb7990a81bfb085de1d0fd7413d) (2023-03-18 11:10:03)</sup>

- [x] **Confirm overwrite in CopyFilesInList**
<sup>Commit [a151ecb](https://github.com/wmelvin/ImagePicker/commit/a151ecb5f9191688f01b87ec597dfbd9ff7d1c3b) (2023-03-18 13:28:50)</sup>

- [x] **Add LastCopyDir to AppOptions**
<sup>Commit [08a1fb5](https://github.com/wmelvin/ImagePicker/commit/08a1fb55cd31cd5c49fd6d9b8bf15d8bd1b62319) (2023-03-18 14:30:56)</sup>

---

- [x] **Specify directory separately in Save dialog.**
<sup>Commit [d78dc55](https://github.com/wmelvin/ImagePicker/commit/d78dc55a909f460eedd3ef51238310db4792c82a) (2023-03-18 16:39:35)</sup>

---

Use `OpenDocument` from the `LCLIntf` unit to open the options file using the default associated application for text files.

Docs: [Executing External Programs](https://wiki.lazarus.freepascal.org/Executing_External_Programs#LCLIntf_Alternatives), [OpenDocument](https://wiki.lazarus.freepascal.org/OpenDocument)

- [x] **Open options file using associated app for text files**
<sup>Commit [e875273](https://github.com/wmelvin/ImagePicker/commit/e87527383e71784fc2bdf69436371ef8010ea50d) (2023-03-19 20:56:34)</sup>

- [x] **Rename options file**
<sup>Commit [dbf8908](https://github.com/wmelvin/ImagePicker/commit/dbf8908da061c31069c2e2d404a24eb941133387) (2023-03-19 21:44:19)</sup>

---

Tools/Options OpenDocument not working on Windows.

Docs: [MkDir](https://www.freepascal.org/docs-html/rtl/system/mkdir.html), [CreateDir](https://www.freepascal.org/docs-html/rtl/sysutils/createdir.html), [ForceDirectories](https://www.freepascal.org/docs-html/rtl/sysutils/forcedirectories.html)

- [x] **Use ForceDirectories. Tools-Options opens folder**
<sup>Commit [cc1b95d](https://github.com/wmelvin/ImagePicker/commit/cc1b95db6000f7b575e3c7ac8bb551dd2696226f) (2023-03-20 09:09:48)</sup>

---

- [x] **Add checkbox to control looping.**
<sup>Commit [e9e6284](https://github.com/wmelvin/ImagePicker/commit/e9e6284c67be04719aeb9165fb4fc6bdfd56d2c8) (2023-03-24 11:30:42)</sup>

- [x] **Update tab order.**
<sup>Commit [5025521](https://github.com/wmelvin/ImagePicker/commit/5025521cc8d9f82b235b472019f9b26df435d868) (2023-03-24 11:33:11)</sup>

- [x] **Store DoLoop and SpeedMs in AppOptions.**
<sup>Commit [f1d3c89](https://github.com/wmelvin/ImagePicker/commit/f1d3c89c1b88353b585cd3f11b393445edf771b2) (2023-03-24 12:01:39)</sup>

---

- [x] **Replaced default icon.**
<sup>Commit [bfeb31b](https://github.com/wmelvin/ImagePicker/commit/bfeb31b0cd784beef053d1a35ed95f1b3b554779) (2023-03-25 07:25:09)</sup>

- [x] **Add note re TTrackBar handling.**
<sup>Commit [84ccbc9](https://github.com/wmelvin/ImagePicker/commit/84ccbc96f96070c4ee6b0811b64600471f47f7fc) (2023-03-25 08:53:23)</sup>

- [x] **Add Windows executable name to .gitignore**
<sup>Commit [1f079ca](https://github.com/wmelvin/ImagePicker/commit/1f079ca4146f4dd7297c10f3c10d73dfc48cd121) (2023-03-25 08:58:23)</sup>

---

Option to recurse sub-folders on open image location.

Docs: [Enum Type](https://wiki.lazarus.freepascal.org/Enum_Type)

- [x] **Prompt to scan sub-folders for image files**
<sup>Commit [939dd49](https://github.com/wmelvin/ImagePicker/commit/939dd4937489ed5d5b90ad28ac7ee722eaa912c7) (2023-03-31 19:15:43)</sup>

---

Separate menu item for Open Folder vs Open File.

- [x] **Add 'Open Folder' menu item and OpenDirDialog.**
<sup>Commit [f04d2d9](https://github.com/wmelvin/ImagePicker/commit/f04d2d91d0ab11dfd2db96070e116b6305c980ae) (2023-04-01 09:00:38)</sup>

---

- [x] **New custom icon**
<sup>Commit [e212831](https://github.com/wmelvin/ImagePicker/commit/e21283119c732f5f94a9d85d2cc9dea700ecbb5d) (2023-04-12 14:24:19)</sup>

- [x] **Update app icon**
<sup>Commit [617242c](https://github.com/wmelvin/ImagePicker/commit/617242cc02a92ff44b72c8e92dc46e586494090d) (2023-05-19 08:08:56)</sup>

- [x] **Revised app icon**
<sup>Commit [50dd2fa](https://github.com/wmelvin/ImagePicker/commit/50dd2fa75fee7e6186e8c30f68c27e21a6a2eabb) (2023-05-19 22:04:36)</sup>

- [x] **Update app icon**
<sup>Commit [5d7ce1a](https://github.com/wmelvin/ImagePicker/commit/5d7ce1aca7814fea15c8b5efa0da7bc864ead269) (2023-06-04 09:40:10)</sup>

---

Docs: [Clipboard](https://wiki.freepascal.org/Clipboard)

- [x] **Copy file paths to clipboard**
<sup>Commit [a247cd5](https://github.com/wmelvin/ImagePicker/commit/a247cd5da75db355d06ffe4f0f67055ccba91265) (2023-06-04 12:24:19)</sup>

---

- [x] **Refactor rename ListBox1 to Picks**
<sup>Commit [ff8d4c9](https://github.com/wmelvin/ImagePicker/commit/ff8d4c992060ca166b0940be536412e3a0b4c933) (2023-06-05 14:17:53)</sup>

---

- [x] **Fix anchoring of Copy button**
<sup>Commit [47b3a32](https://github.com/wmelvin/ImagePicker/commit/47b3a32885b838c2b65c04574615e847c58dee34) (2023-06-05 14:42:23)</sup>

---

- [x] **Ask to clear picks when opening file or dir**
<sup>Commit [dd4fd3e](https://github.com/wmelvin/ImagePicker/commit/dd4fd3e0171103df731fd1360e109c3b9ab23639) (2023-06-05 19:46:17)</sup>

- [x] **Remove some commented-out code**
<sup>Commit [c622339](https://github.com/wmelvin/ImagePicker/commit/c622339ad5b4c746027498c7b154126514eed21a) (2023-06-06 08:30:48)</sup>

---

- [x] **Refactor rename ImageList1 to Glyphs**
<sup>Commit [9648bf7](https://github.com/wmelvin/ImagePicker/commit/9648bf77349951dd8c85e9ad1b7e3091463010b3) (2023-06-09 08:51:06)</sup>

- [x] **Move save and load picks to new unit**
<sup>Commit [cf9b699](https://github.com/wmelvin/ImagePicker/commit/cf9b69949608886a309138a824b39356a2874bbe) (2023-06-09 15:15:08)</sup>

---

- [x] **Handle showing picks where multiple source dirs**
<sup>Commit [c7effef](https://github.com/wmelvin/ImagePicker/commit/c7effef0261fb41c3cf78f1eedf134f3a581319b) (2023-06-11 11:02:19)</sup>

- [x] **Edit message text in AskToClearPicks**
<sup>Commit [86f66d8](https://github.com/wmelvin/ImagePicker/commit/86f66d85afce1ffc17aa6e42194e59ede13ce302) (2023-06-11 11:12:17)</sup>

---

- [x] **Named const for ImageIndex changed by code**
<sup>Commit [44109db](https://github.com/wmelvin/ImagePicker/commit/44109dbbaf271d1f62922e5fcd0c5a88c56b0394) (2023-07-02 15:26:25)</sup>

---

**Refactoring**

- [x] **Refactor rename Form1 to MainForm**
<sup>Commit [9583134](https://github.com/wmelvin/ImagePicker/commit/958313434fcafa7abf8538f3613c19e2fae482b6) (2023-07-12 08:24:03)</sup>

- [x] **Refactor rename buttons**
<sup>Commit [4849523](https://github.com/wmelvin/ImagePicker/commit/484952348268f09110ffcf8701fe230ecb9f546a) (2023-07-13 08:03:23)</sup>

- [x] **Refactor rename menu objects**
<sup>Commit [e6f3aa6](https://github.com/wmelvin/ImagePicker/commit/e6f3aa62fe7888d01927db55f2e8cdbfc48abef0) (2023-07-14 07:28:16)</sup>

- [x] **Refactor rename more buttons**
<sup>Commit [3dab4b7](https://github.com/wmelvin/ImagePicker/commit/3dab4b7dae9ed89e50325ce79ef22f69ee05bed8) (2023-07-14 07:35:54)</sup>

- [x] **Refactor rename panels**
<sup>Commit [f5e4a65](https://github.com/wmelvin/ImagePicker/commit/f5e4a6565ee2d1fc19942544eacde0e5835d8875) (2023-07-14 07:44:47)</sup>

- [x] **Refactor rename single objects**
<sup>Commit [caafc0f](https://github.com/wmelvin/ImagePicker/commit/caafc0f60ed99a358542b84efd061417df8c6620) (2023-07-16 13:40:10)</sup>

- [x] **Refactor sort MainForm class declaration**
<sup>Commit [973c850](https://github.com/wmelvin/ImagePicker/commit/973c850ce91c0e422961329b149891ef9014908c) (2023-07-16 14:23:46)</sup>

- [x] **Refactor sort MainForm implementation**
<sup>Commit [3a0efac](https://github.com/wmelvin/ImagePicker/commit/3a0efac8d6451b582387cfb3f986e35d7c01f452) (2023-07-16 14:31:13)</sup>

---

- [x] **Handle missing files on loading saved list**
<sup>Commit [046d31a](https://github.com/wmelvin/ImagePicker/commit/046d31a72478f66033b9fa9c40eb9efcb09ef200) (2023-10-05 16:49:23)</sup>

---

- [x] **Add LastLoadDir to AppOptions**
<sup>Commit [6fdf6ee](https://github.com/wmelvin/ImagePicker/commit/6fdf6eeb8650ba4b62347112d2a92648277c4164) (2023-10-06 10:40:36)</sup>

- [x] **Fix using wrong source for LastOpenDir**
<sup>Commit [6dece3a](https://github.com/wmelvin/ImagePicker/commit/6dece3a8dc086d0fb6960d0285299a7ce4872275) (2023-10-06 10:57:36)</sup>

---

- [x] **Select item after Remove item from Picks**
<sup>Commit [c91d31e](https://github.com/wmelvin/ImagePicker/commit/c91d31e10914577fef7ec46ef70a3af047de8efa) (2023-10-23 10:46:34)</sup>

---

- [x] **Open folder containing current image**
<sup>Commit [639fa57](https://github.com/wmelvin/ImagePicker/commit/639fa570272b9899588cdfa09ddb34428710aea4) (2023-10-30 11:03:24)</sup>

---

Docs: [TRadioGroup](https://wiki.lazarus.freepascal.org/TRadioGroup)

- [x] **Add file naming options to CopyFilesInList**
<sup>Commit [4be6b3a](https://github.com/wmelvin/ImagePicker/commit/4be6b3a745f631625323d33f6fd1671d8c64bc68) (2023-10-30 15:01:54)</sup>

---

- [x] **Add 'Sort picks' to Tools menu. Expand devnotes.md**
<sup>Commit [b980a0e](https://github.com/wmelvin/ImagePicker/commit/b980a0ea8fbc3eb2d0415eb6f1037a3399c538ab) (2023-11-14 14:06:35)</sup>

---

Docs: [Calendar Versioning](https://calver.org/)

- [x] **Use calver. Update editTag on show image in list**
<sup>Commit [ab69ec8](https://github.com/wmelvin/ImagePicker/commit/ab69ec8ea30873ffd04921ef725e765002ee02fa) (2023-11-26 15:09:53)</sup>

---

Docs: [OpenURL](https://wiki.freepascal.org/OpenURL)

- [x] **Add About dialog**
<sup>Commit [b9f90a8](https://github.com/wmelvin/ImagePicker/commit/b9f90a868a8c4e72db34364ddafddc3404b96aa1) (2023-11-29 16:11:06)</sup>

- [x] **Add to About dialog**
<sup>Commit [4947ac1](https://github.com/wmelvin/ImagePicker/commit/4947ac15684833a575e0cd87afebc2b054482ce6) (2023-11-29 17:09:36)</sup>

- [x] **Add LICENSE**
<sup>Commit [9c2042c](https://github.com/wmelvin/ImagePicker/commit/9c2042c543ee5a604f50e38c4a19eb36fcb8767f) (2023-11-29 19:49:22)</sup>

---

Docs: [Application manifests - Win32 apps](https://learn.microsoft.com/en-us/windows/win32/sbscs/application-manifests#assemblyidentity)

- [x] **Update project name in manifest**
<sup>Commit [0fd760b](https://github.com/wmelvin/ImagePicker/commit/0fd760b43b593a0cb252e7927ace50c4aa57be1e) (2023-12-01 20:39:17)</sup>

---

While using ImagePicker to collect and tag a series of screenshots, it seemed that the process could be improved if there was a separate *mode* for working only with the list of images already picked.

A **picks-mode** would:

- Disable navigation within the source images folder.
- Reassign some navigation functions to work within the *picks* list instead of the source images.

This would make it easier to **focus on the picks list** for selecting, tagging, reordering, and removing items.

- [x] **Add picks-mode button and initial code**
<sup>Commit [d5fb072](https://github.com/wmelvin/ImagePicker/commit/d5fb07297fb015550c849feca4e071476b9921b6) (2023-12-12 18:16:48)</sup>

- [x] **Implement picks-mode**
<sup>Commit [b1f04c5](https://github.com/wmelvin/ImagePicker/commit/b1f04c502b0f7d91220f1b9f28181e25bcb9b808) (2023-12-12 21:43:24)</sup>

- [x] **Change editTag caption to assign Alt+G**
<sup>Commit [52bbee6](https://github.com/wmelvin/ImagePicker/commit/52bbee648064f6d5cbeb42a09b9a1655551e0e1a) (2023-12-16 15:09:52)</sup>

---

Additional changes after using picks-mode.

- [x] **Cancel picks-mode on file-open or load-list**
<sup>Commit [09c0924](https://github.com/wmelvin/ImagePicker/commit/09c092436c6552eebdec7d0a72062233cc5d4e6c) (2023-12-18 18:49:43)</sup>

- [x] **Enable Home and End keys in picks-mode**
<sup>Commit [efeedd0](https://github.com/wmelvin/ImagePicker/commit/efeedd01d6e4f7049d17e439c6b22f750d5af522) (2023-12-20 17:59:59)</sup>

---

- [x] **Move About to new Help menu**
<sup>Commit [dc3096c](https://github.com/wmelvin/ImagePicker/commit/dc3096c62798bac18ef6774a1b56c067435970cb) (2023-12-20 18:26:05)</sup>

---
