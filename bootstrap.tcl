# Bootstraps Tkabber using its "starkit hatch".

proc starkit_init args {
	append ::toolkit_version " (pack rev.1)"
}

source [file join [file dir [info script]] Tkabber tkabber.tcl]
