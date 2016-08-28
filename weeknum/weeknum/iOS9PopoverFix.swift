// Fix for IOS 9 pop-over arrow anchor bug
// ---------------------------------------
// - IOS9 points pop-over arrows on the top left corner of the anchor view
// - It seems that the popover controller's sourceRect is not being set
//   so, if it is empty  CGRect(0,0,0,0), we simply set it to the source view's bounds
//   which produces the same result as the IOS8 behaviour.
// - This method is to be called in the prepareForSegue method override of all
//   view controllers that use a PopOver segue
//
//   example use:
//
//          override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
//          {
//             fixIOS9PopOverAnchor(segue)
//          }
// Based on http://stackoverflow.com/a/33070565/1504197

import UIKit

extension UIViewController
{
    func fixIOS9PopOverAnchor(segue:UIStoryboardSegue?)
    {
        guard #available(iOS 9.0, *) else { return }
        if let popOver = segue?.destinationViewController.popoverPresentationController,
            let anchor  = popOver.sourceView
            where popOver.sourceRect == CGRect()
                && segue!.sourceViewController === self
        { popOver.sourceRect = anchor.bounds }
    }       
}
