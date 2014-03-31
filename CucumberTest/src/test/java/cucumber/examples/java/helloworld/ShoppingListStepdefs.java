package cucumber.examples.java.helloworld;

import java.io.IOException;
import java.util.List;

import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.examples.java.helloworld.ShoppingList;

import static org.junit.Assert.assertEquals;

public class ShoppingListStepdefs {
	private final ShoppingList shoppingList = new ShoppingList();
	private StringBuilder printedResult;
	
	@Given("^ *쇼핑 리스트가 주어졌음$")
	public void a_shopping_list_with_name_and_count(List<Item> items) {
		for (Item item : items) {
			shoppingList.addItem(item.name, item.count);
		}
	}
	
	@When("^ *그 리스트를 출력하면$")
	public void I_print_that_list() throws IOException {
		printedResult = new StringBuilder();
		shoppingList.print(printedResult);
	}
	
	@Then("^ *다음과 같은 결과가 나와야 함$")
	public void it_should_look_like(String expectedResult) {
		assertEquals(expectedResult, printedResult.toString());
	}
	
	public static class Item {
		private String name;
		private int count;
	}

}
