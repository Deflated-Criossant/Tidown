# Tidown
_A simple, yet efficient, Tital downloader._  
Join our chat on Discord: https://discord.gg/5WJcVTU
___

## Storytime!
After _"the great death"_ of the [node-spotify-downloader](https://github.com/Lordmau5/node-spotify-downloader) I looked into alternatives to get music streams and pipe them to files.  
For the not-so-tech-savvy people: Yes, that means downloading.  
Spotify has really cracked down on the security (Login captcha, more errors when trying to get a stream URL, ...) and I just can't bother with it anymore. The source code is still up for people to play around though, if they want.

The other alternative I looked into was Deezer, which... well... [Deezloader](https://github.com/s3condAtall/Deezloader), which was kindly reuploaded by [@s3condAtall](https://github.com/s3condAtall) on Github, wasn't working **at all** for me.  
I needed to find something else...

Tidal seemed good and a few people (only like 2-3) told me about it. I didn't even know it existed before that!  
Now, there are some APIs for NodeJS out there that I wanted to try out... especially because it seems that Tidal has dedicated API-endpoints to get a Stream- or Offline-URL. (They're using it for the Web-App as well, so why shouldn't I be able to?)  
I signed up for the trial, which is 1€ for 30 days, and started hacking code into [Atom](https://atom.io/) (which is a **great** editor by the way!)

After 2 days I had a working prototype, which I actually leaked proof of in our node-spotify-downloader [Gitter.im chat](https://gitter.im/Lordmau5/node-spotify-downloader).

### And now, here it is! - _Tidown!_
___

## How do I use it?
### Preparations / Setup
First of all you need an account on the music streaming service [Tidal](http://tidal.com/).  
Here you have 2 options:
- **TIDAL Premium** (10€/mo), which will give you 96kbit or 320kbit
- **TIDAL HiFi** (20€/mo), which will give you 96kbit, 320kbit **OR EVEN** lossless!

I am *GLAD* that Tidal is not available for free. This makes me feel a little more safe about this project.  

If you don't have NodeJS yet, go download it from over here:  
https://nodejs.org/en/  
v4.5.0 or higher is required.

Afterwards, just download the repository and unpack it to some folder.  
In that folder, open up a CMD or terminal and type the following 2 commands:
```
npm install
npm install -g iced-coffee-script
```

After you've done that, you need to copy or rename the file `config.iced.example` to `config.iced`.  
Then, open it with your favorite text editor and fill out the fields
- `username`
- `password`
- `token`

That concludes the setup.

### Basic usage
As example, I'm going to take the album _"Drunken Lullabies"_ by the band _"Flogging Molly"_.  
The link in your browser looks like this:  
`https://listen.tidal.com/album/4571261`  
Now, what we need from that link is the type of it, in this case `album`, and the ID, in this case `4571261`.

To start the download on this album, all we need to do is run the following command in the CMD / terminal:  
`iced index.iced -t album -q high -i 4571261`  
This will start a download of the type `album` with the quality `high` (320kbit) and the ID `4571261`.  
Additionally we could use `-l <limit>` or `--limit <limit>` to set the maximum parallel downloads. The default of this is `10`.

A full documentation on how to use the tool can be found by typing just `iced index.iced`, `iced index.iced --help` or by supplying invalid / missing parameters.

For simplicity's sake, and because I know some people are just lazy ( ;) ), here's the list of the parameters and what they do:

| Parameter     | Alternative   | Valid input       | Optional          | Description   |
|:-------------:|:-------------:|:-----------------:|:-----------------:|:-------------:|
| `-h`          | `--help`      | -                 | Yes               | output usage information |
| `-V`          | `--version`   | -                 | Yes               | output the version number |
| `-t`          | `--type`      | `Track`, `Album`, `Playlist` | No     | Type of download |
| `-q`          | `--quality`   | `Low`, `High`, `Lossless` | Yes (default: High) | Quality (Lossless requires HiFi subscription!) |
| `-i`          | `--id`        | -                 | No                | ID of the Track / Album / Playlist |
| `-l`          | `--limit`     | `integer value`   | Yes (default: 10) | Amount of maximum parallel downloads |
| `-s`          | `--skip`      | -                 | Yes               | Skips Tagging |

### Tagging
#### Windows 
Windows needs the `ffmpeg.exe` in the root directory or in the `PATH`.

#### Mac OS X 
Download `ffmeg` pre-built from http://ffmpegmac.net unzip and place in root directory or in the `PATH`, and this will auto-tag your music. 

You need to also allow installation from unkown developer's enabling in your app store prefrences.

### License
The license can be found in the corresponding `LICENSE.md` file.
