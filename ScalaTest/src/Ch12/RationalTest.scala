package Ch12

/**
  * Created by terzeron on 2016. 12. 19..
  */
object RationalTest {
  def main(args: Array[String]): Unit = {
    val x = new Rational(12, 4)
    val y = new Rational(13, 5)
    println(x > y)
    println(x <= y)
  }
}

class Rational(n: Int, d: Int) extends Ordered[Rational] {
  private val g = gcd(n.abs, d.abs)
  val number = n / g
  val denom = d / g
  private def gcd(a: Int, b: Int): Int = if (b == 0) a else gcd(b, a % b)

  def compare(that: Rational) = (this.number * that.denom) - (that.number * this.denom)
}
