module calcloc.app;

import std.path;
import std.file;
import std.stdio;
import std.string;
import core.stdc.stdlib : exit;

const string usage = "Usage: %s <directories/files>";

size_t files;
size_t blank;
size_t comment;
size_t code;

void CountLines(string file) {
	if (!exists(file)) {
		stderr.writefln("'%s' doesn't exist", file);
		exit(1);
	}

	if (isFile(file) && (file.extension() == ".cal")) {
		++ files;

		auto lines = readText(file).split("\n");

		foreach (ref line ; lines) {
			if (line.strip() == "")          ++ blank;
			else if (line.strip()[0] == '#') ++ comment;
			else                             ++ code;
		}
	}
	else if (isDir(file)) {
		foreach (e ; dirEntries(file, SpanMode.shallow)) {
			CountLines(e.name);
		}
	}
}

int main(string[] args) {
	if (args.length == 1) {
		writefln(usage.strip(), args[0]);
		return 0;
	}

	foreach (ref arg ; args[1 .. $]) {
		CountLines(arg);
	}

	writefln("Read %d files\n", files);
	writefln("Blank:   %d", blank);
	writefln("Comment: %d", comment);
	writefln("Code:    %d", code);
	writefln("Sum:     %d", blank + comment + code);
	return 0;
}
