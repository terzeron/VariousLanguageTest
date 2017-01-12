package Ch18

/**
  * Created by terzeron on 2017. 1. 9..
  */
class BankAccount {
  private var bal: Int = 0

  def balance: Int = bal

  def deposit(amount: Int): Unit = {
    require(amount > 0) // assert
    bal += amount
  }

  def withdraw(amount: Int): Boolean =
    if (amount > bal) false
    else {
      bal -= amount
      true
    }
}

object BankAccountTest {
  def main(args: Array[String]): Unit = {
    val account = new BankAccount
    println(account deposit 100)
    println(account.balance)
    println(account withdraw 80)
    println(account.balance)
    println(account withdraw 80)
    println(account.balance)
  }
}
