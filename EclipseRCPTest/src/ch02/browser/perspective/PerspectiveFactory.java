package ch02.browser.perspective;

import org.eclipse.ui.IPageLayout;
import org.eclipse.ui.IPerspectiveFactory;

public class PerspectiveFactory implements IPerspectiveFactory {
	public void createInitialLayout(IPageLayout layout) {
		String editorArea = layout.getEditorArea();
		layout.setEditorAreaVisible(false);
		layout.addView(BookMarksView.ID, IPageLayout.LEFT, 0.2f, editorArea);
		layout.addView(WebBrowserView.ID, IPageLayout.LEFT, 0.8f, editorArea);
	}
}
