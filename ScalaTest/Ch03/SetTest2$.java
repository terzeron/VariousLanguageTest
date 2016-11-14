object SetTest2 {
  def main(args: Array[String]) {
    val movieSet = Set("Hitch", "Poltergeist")
    movieSet += "Shrek" // val인데도 변경 가능
    println(movieSet)
  }
}
