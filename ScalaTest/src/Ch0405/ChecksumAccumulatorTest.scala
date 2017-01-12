import ChecksumAccumulator.calculate

object ChecksumAccumulatorTest {
  def main(args: Array[String]) {
    for (arg <- args)
      println(arg + "; " + calculate(arg))
  }
}
