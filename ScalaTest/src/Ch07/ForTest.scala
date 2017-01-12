package Ch07

/**
  * Created by terzeron on 2016. 11. 21..
  */
object ForTest {
  def fileLines(file: java.io.File) = scala.io.Source.fromFile(file).getLines().toList

  def main(args: Array[String]): Unit = {
    val filesHere = (new java.io.File(".")).listFiles

    for (
      file <- filesHere
      if file.isFile
      if file.getName.endsWith(".scala")
    ) println(file)

    for (i <- 1 to 4)
      println(i)

    for (i <- 1 until 4)
      println(i)

    def grep(pattern: String) =
      for (
        file <- filesHere
        if file.getName.endsWith(".scala");

        line <- fileLines(file)
        if line.trim.matches(pattern)
      ) println(file + ": " + line.trim)
    grep(".*gcd.*")

    def scalaFiles =
      for {
        file <- filesHere
        if file.getName.endsWith(".scala")

        line <- fileLines(file)
        trimmed = line.trim
        if trimmed.matches(".*gcd.*")
      } yield trimmed.length
    for (scalaFile <- scalaFiles)
      println(scalaFile)
  }
}
