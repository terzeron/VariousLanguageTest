package Ch07

/**
  * Created by terzeron on 2016. 11. 21..
  */
object TryTest {
  def main(args: Array[String]): Unit = {
    val n = 1
    val half =
      if (n % 2 == 0)
        n / 2
    else
        throw new RuntimeException("n must be even")

    print(half)
  }
}
