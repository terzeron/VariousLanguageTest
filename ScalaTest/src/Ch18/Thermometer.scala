package Ch18

/**
  * Created by terzeron on 2017. 1. 9..
  */
class Thermometer {
  var celsius: Float = _

  def fahrenheit = celsius * 9 / 5 + 32
  def fahrenheit_= (f: Float) {
    celsius = (f - 32) * 5 / 9
  }
  override def toString  = fahrenheit + "F/" + celsius + "C"
}

object ThermometerTest {
  def main(args: Array[String]): Unit = {
    val t = new Thermometer
    println(t)
    t.celsius = 100
    println(t)
    t.fahrenheit = -40
    println(t)
  }
}
