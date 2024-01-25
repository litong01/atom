def grey:   "\u001b[30m" + . + "\u001b[0m";
def red:    "\u001b[31m" + . + "\u001b[0m";
def green:  "\u001b[32m" + . + "\u001b[0m";
def yellow: "\u001b[33m" + . + "\u001b[0m";
def blue:   "\u001b[34m" + . + "\u001b[0m";
def purple: "\u001b[35m" + . + "\u001b[0m";

def displayLevel:
  . as $level |
  "[" + $level + "]" |
  if ($level == "trace") then blue
  elif ($level == "debug") then blue
  elif ($level == "info") then green
  elif ($level == "warn") then yellow
  elif ($level == "error") then red
  elif ($level == "fatal") then red
  else .
  end;

def displayStringValue(indent):
  if contains("\n") then
    split("\n") |
    map("  " * indent + sub("(?<leadingTabs>[\t]+)";"  " * (.leadingTabs | length);"g")) |
    "\n" + join("\n")
  else .
  end |
  grey;

def displayObjectValue(indent):
  to_entries |
  if length == 0 then
    "{}" | grey
  else
    map(
      ("  " * indent) +
      (.key + ": " | blue) +
      (.value |
        if (type == "string") then displayStringValue(indent + 1)
        elif (type == "object") then displayObjectValue(indent + 1)
        else tojson | grey
        end
      )
    ) |
    "\n" + join("\n")
  end;

def sternlog(inner):
  . as $line |
  try (
    fromjson |
    (.podName | purple) + " " + (.containerName | blue) + " " +
    (.message | . as $message | try (inner) catch $message)
  ) catch $line;

def jsonlog:
  .timestamp as $timestamp |
  try (
    $timestamp | split("T") | .[0] as $date | .[1] as $time |
    ($date + "T" | grey) + $time[:8] + ($time[8:] | grey)
  ) catch (
    ($timestamp // "<no timestamp>") | grey
  ) + " " +
  if .level then (.level | displayLevel) + " " else "" end +
  .msg +
  (del(.timestamp, .level, .msg) | displayObjectValue(1));

def aclog:
  . as $line |
  try (
    fromjson |
    del(.application, .component) |
    jsonlog
  ) catch $line;

def nlog:
  . as $line |
  try (
    split("\t") |
    {
      timestamp: .[0],
      level: (.[1] | ascii_downcase),
      msg: .[2],
    } + (.[3] | fromjson) |
    del(.controller, .controllerGroup, .controllerKind, .namespace, .name) |
    jsonlog
  ) catch $line;