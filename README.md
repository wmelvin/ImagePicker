# ImagePicker

*ImagePicker* is a desktop application for selecting images and saving the list to a text file for use in other applications. It is implemented using the [Lazarus](https://www.lazarus-ide.org/) IDE for Free Pascal.

More details about the development of this application are in [devnotes](devnotes.md).

## Picking from a set of screenshots

The initial use-case for ImagePicker was to select screenshot images created by [TimeSnapper](https://www.timesnapper.com/) (mostly from an older version), or another screenshot tool, to extract specific screenshots to use in project documentation.

![Screenshot of picking from a large set of TimeSnapper screenshots](readme_images/pick-screenshots-013.jpg)
Picking screenshots - running on Windows. [Animation](pick-screenshots.md)

## Picking from a set of photos

ImagePicker can be used to browse and select from any set of images.

![Screenshot of picking from a set of photos](readme_images/pick-photos-010.jpg)
Picking photos - running on Linux (Ubuntu). [Animation](pick-photos.md)

## Scope and Limitations

As stated above, this application was created mainly to review and select from sets of screenshot images. While **ImagePicker** can be used for any set of images, it **does not rotate images**. Many image viewer applcations can read the [Exif](https://en.wikipedia.org/wiki/Exif) *Orientation* tag, when present in the image metadata, and automatically rotate images.


## License

The source code for the **ImagePicker** application itself is licensed using the [MIT license](LICENSE). None of the source code for Free Pascal, Lazarus, or its component libraries, was modified in any way.

The Lazarus IDE and Free Pascal compiler use versions of the GPL and LGPL licenses. However, according to the [licensing documentation](https://wiki.lazarus.freepascal.org/licensing), executables produced by Lazarus are not subject to the same licensing requirements.

> The GPL does not cover any application binary created with Lazarus. The application binary itself is only limited by the components you actually link to, and in the FPC/Lazarus project those are all LGPL_with_exception. So though potentially confusing this licensing is not a problem when developing binaries with Lazarus, even if you have commercial components with designtime parts.

## Usage

### Menus

#### File

##### File / Open file

Use the file-open dialog to select a file. Other image files in the same folder will be in the set of images to navigate and pick from. The file that was opened will be the current image displayed.

##### File / Open folder

Use the folder-open dialog to select a folder. All image files in the folder will be in the set of images to navigate and pick from.

##### File / Load List

Load a previously saved list of picked images. Provided the folder where the images were picked from is accessible, the images will be displayed.

##### File / Save List

Save the current list of picked images to a file. The file is a text file that can be loaded into the application later. It also is in a format that can be used to create a script to do operations with the list of images using some other tool.

##### File / Current Folder

Open the folder than contains the current image.

##### File / Exit

Exit the ImagePicker application.

#### Tools

##### Tools / Options

Open the **folder** containing the file `ImagePicker-Options.txt`. The options file is a text file containing saved settings as key-value pairs.

##### Tools / Copy files

Open the **Copy Files** dialog.

![Copy Files dialog](readme_images/copy-files-dialog.jpg)

The following options are available for copying the picked image files:

**Copy to Folder** - Enter or browse for the destination folder.

To have the files copied to a new sub-folder under the selected destination, check the box for *Copy files to a new sub-folder named per the current date and time.*

There are five **File Name Format:** options:

- `FileName-Tag`
- `Sequence-FileName-Tag`
- `Title-FileName-Tag-Sequence`
- `Title-Sequence-Tag`
- `Title-Tag-Sequence`

The file naming components are as follows:

`FileName` is the original file name of the image.

`Sequence` comes from the order of the images in the *Picks* list.

`Tag` comes from the optional *Tag* as applied to individual images in the *Picks* list.

`Title` comes from the value in the *Title* text box.

##### Tools / Sort picks

Sort the file names in the Picks list.

#### Help

##### Help / Online docs

Open the URL for the README file in using default web browser.

##### Help / About

Display the *About* dialog box. 

### Keyboard commands

Key    | Default-mode        | Picks-mode
-------|---------------------|-------------------
`Home` | Display first image | Select first pick

*TODO: ...*

---
