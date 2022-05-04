# Download Blocker

Chrome web store link: https://chrome.google.com/webstore/detail/download-blocker/kippogcnigegkjidkpfpaeimabcoboak

## What is it?

Download Blocker is a Google Chrome extension which blocks certain files from being downloaded, based on a number of different data / metadata properties. It was created as a way to prevent HTML smuggling attacks, but it can also block downloads from webservers too.

HTML smuggling is essentially a technique for bypassing web-proxies / firewalls that perform content inspection on files downloaded from a server. It does this by using HTML5 APIs to provide a client-side download using javascript, without making a request to a webserver. For an in-depth description of HTML smuggling, please see the references below.

## Change Log

### 0.1.6
* The 'hostname' and 'basedomain' exception types now support arrays as well as strings.
* Fixed bug which meant that only the first exception in a rule was actually checked.
* Fixed issue which meant that base64 encoded data:// URLs would not be processed for SHA256 calculation or file inspection.
* Rewrote how file metadata (SHA256, file inspection data) is handled which means that this information can trigger a rule action even if it is received after the file has finished downloading.
* The {timestamp} placeholder now uses the time the download was initiated instead of the time the alert notification was sent.

### 0.1.5
* Fixed bug which meant an empty response from the server when sending an alert was handled as an error.
* Added 'ruleName' config parameter to aid identifying which rule triggered an action.
* Fixed parameters not being encoded properly when used in an alert URL.
* Added the 'urlScheme' configuration filter to block downloads based on the URL scheme of the referring page. (e.g. file, http, https)
* Fix for an oversight which may have caused the inferred URL to take precedence over the one provided by the webpage. (See 0.1.0)

Full change log available [here](CHANGELOG.md)

## Configuration

This extension was created with enterprises in mind, so configuration isn't available to the end user. Instead, settings are applied via the 'Config' registry value under the following key:

`HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\3rdparty\extensions\kippogcnigegkjidkpfpaeimabcoboak\policy` (For Google Chrome)
`HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge\3rdparty\extensions\kippogcnigegkjidkpfpaeimabcoboak\policy` (For Chromium Edge)

![Registry Configuration - Chrome](https://github.com/SecurityJosh/DownloadBlocker/raw/master/registry_chrome.png)



The JSON data should be minified before setting the registry value, for example by using [this](https://codebeautify.org/jsonminifier) tool.

**Note: It can take a while for Chrome to apply an updated policy. For testing purposes, you may need to go to chrome://policy or edge://policy to check if the policy has been loaded. You can also manually reload the policies via the 'Reload Policies' button. Note that Edge doesn't appear to display extension configuration settings, but they are actually still loaded.**

### Banned Extensions (Required)

The bannedExtensions property supports an array containing either:
* The extensions to ban (Without the leading '.')
* The wildcard operator ("*")

### Origin (Required)

Property name: origin

* Local - The file was downloaded via javascript
* Server - The file is hosted via a web server
* Any - Either of the above

### ruleName (Optional)

The ruleName property is simply an identifier which can be used in the alert config or message template fields. It's useful to help pinpoint which rule has triggered.

### urlScheme (Optional)

Property name: urlScheme (Array)

This property is intended to used in combination with an origin = Local filter. When used in this way, the urlScheme filter can be used to block downloads based on their url protocol, e.g file, http, https etc..

This can be used, for example, to block all HTML Smuggled downloads which originate from a local webpage on the user's computer. (e.g. via an email attachment) Since Chrome can't, by default, run content scripts in these local webpages, a rule which blocks files based on content inspection won't work for these files. This property allows you to blanket ban these files which can't be inspected.


### fileNameRegex (Optional)

Property name: fileNameRegex

The fileNameRegex property allows you to filter for file names that match a given regex pattern. The pattern is tested against the whole file name, including extension. Be aware that you will need to double-escape any backslashes in your regex string so that the JSON remains valid.
