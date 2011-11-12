organization := "fr.arnk"

name := "sosmessage-api"

version := "1.0-SNAPSHOT"

seq(com.github.retronym.SbtOneJar.oneJarSettings: _*)

libraryDependencies ++= Seq(
  "net.databinder" %% "unfiltered-filter" % "0.5.0",
  "net.databinder" %% "unfiltered-jetty" % "0.5.0",
  "net.databinder" %% "unfiltered-json" % "0.5.0",
  "com.mongodb.casbah" %% "casbah" % "2.1.5-1",
  "ch.qos.logback" % "logback-classic" % "0.9.28",
  "net.databinder" %% "unfiltered-spec" % "0.5.0" % "test"
)
