package ch02.browser.perspective;

import ViewPart;

public class WebBrowserView extends ViewPart {
	static public String ID = WebBrowserView.class.getName();
	
	private Combo urlCombo;
	private Browser browser;
	
	private Action actionBack;
	private Action actionForward;
	private Action actionHome;
	private Action actionAddBookmark;
	
	private final String startUrl = "http://naver.com";
	
	public static ImageDescriptor ICON_HOME = BrowserActivator.getImageDescriptor
}
