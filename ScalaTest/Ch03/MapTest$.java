object MapTest {
  def main(args: Array[String]) {
    val treasureMap = Map[Int, String]()
    treasureMap += (1 -> "go to island")
    treasureMap += (2 -> "find big x on ground")
    treasureMap += (3 -> "dig")
    println(treasureMap(2))

    val romanNumeral = Map(1 -> "I", 2 -> "II", 3 -> "III", 4 -> "IV", 5 -> "V")
    println(romanNumeral(4))

  }
}
