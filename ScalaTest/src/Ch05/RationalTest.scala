object RationalTest {
  def main(args: Array[String]): Unit = {
    val r = new Rational(3, 5)
    println("r=" + r);

    val r2 = new Rational(4, 6)
    println("r2=" + r2)
    val r3 = r+r2
    println("r3=" + r3)
    var r4 = r*r2
    println("r4=" + r4)
    val r5 = new Rational(100, 50)
    println("r5=" + r5)

    val r6 = new Rational(3, 4)
    println(r6 * 7)
    println(r6 + 2)

    implicit def intToRational(x: Int) = new Rational(x)
    println(7 * r6)
  }
}