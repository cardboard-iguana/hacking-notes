# Fix EXIF Data on Google Photos Exports

Google Photos doesn't save date/time changes, descriptions, or GPS data set in-app to the photos' EXIF data. Instead, when using Google Takeout this information is exported as JSON sidecar files (apparently Google had to bikeshed something rather than just using XMP).

Fortunately, ExifTool can merge the data from these files back into the exported photographs:

```bash
exiftool -r -d %s \
         -tagsfromfile "%d/%F.json" \
                       "-GPSAltitude<GeoDataAltitude" \
                       "-GPSLatitude<GeoDataLatitude" \
                       "-GPSLatitudeRef<GeoDataLatitude" \
                       "-GPSLongitude<GeoDataLongitude" \
                       "-GPSLongitudeRef<GeoDataLongitude" \
                       "-Keywords<Tags" \
                       "-Subject<Tags" \
                       "-Caption-Abstract<Description" \
                       "-ImageDescription<Description" \
                       "-DateTimeOriginal<PhotoTakenTimeTimestamp" \
         -ext "*" -overwrite_original -progress \
         --ext json $GOOGLE_PHOTOS_DIR
```

Note that this will fail for any photos with a timestamp before 1970; for these photos, replace `"-DateTimeOriginal<PhotoTakenTimeTimestamp"` with `"-DateTimeOriginal<PhotoTakenTimeFormatted" -d "%b %d, %Y, %I:%M:%S %p UTC"`.

* [How To Correctly Export And Migrate Away From Google Photos](https://legault.me/post/correctly-migrate-away-from-google-photos-to-icloud)
* [ExifTool Dies on One Specific Photo](https://exiftool.org/forum/index.php?topic=10636.0)
* [Google Takeout](https://takeout.google.com/settings/takeout)
* [Extensible Metadata Platform (Wikipedia)](https://en.wikipedia.org/wiki/Extensible_Metadata_Platform)
* [ExifTool](https://exiftool.org/)
