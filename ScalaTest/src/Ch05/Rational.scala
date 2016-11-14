class Rational(n: Int, d: Int) {
  require(d != 0)

  // 멤버변수
  private val g: Int = gcd(n.abs, d.abs)
  val _n = n / g
  val _d = d / g

  private def gcd(a: Int, b: Int): Int = {
    if (b == 0) a else gcd(b, a % b)
  }

  // 보조생성자
  def this(n: Int) = this(n, 1)

  override def toString(): String = {
    return "" + _n + "/" + _d;
  }

  def +(r2: Rational): Rational = {
    return new Rational(n * r2._d + r2._n * d, d * r2._d)
  }

  def +(i: Int): Rational = {
    return new Rational(n + i * d, d)
  }

  def *(r2: Rational): Rational = {
    return new Rational(n * r2._n, d * r2._d)
  }

  def *(i: Int): Rational = {
    return new Rational(n * i, d)
  }
}
