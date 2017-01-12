package Ch09

/**
  * Created by terzeron on 2016. 12. 12..
  */
object FileMatcher {
  private def filesHere = (new java.io.File(".")).listFiles

  def filesEnding(query: String) =
    filesMatching(_.endsWith(query))

  def filesContaining(query: String) =
    filesMatching(_.contains(query))

  def filesRegex(query: String) =
    filesMatching(_.matches(query))

  def filesMatching(matcher: String => Boolean) =
    for (file <- filesHere; if matcher(file.getName))
      yield file

  def main(args: Array[String]):Unit = {
    for (file <- filesRegex(".*scala")) {
      println(file.getName)
    }
  }
}
