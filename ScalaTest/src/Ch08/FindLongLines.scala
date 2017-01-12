package Ch08

/**
  * Created by terzeron on 2016. 11. 28..
  */
object FindLongLines {
  def main(args: Array[String]): Unit = {
    val width = args(0).toInt
    for (arg <- args.drop(1))
      LongLines.processFile(arg, width)
  }

}
