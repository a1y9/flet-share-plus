from typing import Any, Callable, Optional, List
from flet.core.control import Control, OptionalNumber


class SharePlus(Control):
    """
    Share content via the platform's share dialog.
    
    Wraps the share_plus Flutter package.
    
    Usage:
        1. Add SharePlus to your page:
           share = SharePlus(on_share_completed=lambda e: print("Shared!"))
           page.add(share)
           
        2. Call share methods from any control's event handler:
           ft.ElevatedButton("Share", on_click=lambda _: share.share_text("Hello world!"))
    """

    def __init__(
        self,
        # Control
        ref=None,
        disabled=None,
        visible=None,
        data=None,
        #
        # SharePlus callbacks
        #
        on_share_completed: Optional[Callable] = None,
        on_share_dismissed: Optional[Callable] = None,
    ):
        Control.__init__(
            self,
            ref=ref,
            disabled=disabled,
            visible=visible,
            data=data,
        )
        self.on_share_completed = on_share_completed
        self.on_share_dismissed = on_share_dismissed

    def _get_control_name(self):
        return "share_plus"

    # on_share_completed
    @property
    def on_share_completed(self):
        return self._get_event_handler("share_completed")

    @on_share_completed.setter
    def on_share_completed(self, handler):
        self._add_event_handler("share_completed", handler)

    # on_share_dismissed
    @property
    def on_share_dismissed(self):
        return self._get_event_handler("share_dismissed")

    @on_share_dismissed.setter
    def on_share_dismissed(self, handler):
        self._add_event_handler("share_dismissed", handler)
        
    def share_text(self, text: str, subject: Optional[str] = None):
        """à
        Share text content via platform's share dialog.
        
        Args:
            text: Text to share.
            subject: Subject to share with (optional, mainly used for email).
        """
        args = {"text": text}
        if subject is not None:
            args["subject"] = subject
            
        return self.invoke_method("share_text", args)
        
    def share_files(self, file_paths: List[str], text: Optional[str] = None):
        """
        Share files via platform's share dialog.
        
        Args:
            file_paths: List of file paths to share.
            text: Optional text to share with the files.
        """
        args = {"filePaths": ",".join(file_paths)}
        if text is not None:
            args["text"] = text
            
        return self.invoke_method("share_files", args)
    
    def share_uri(self, uri: str):
        """
        Share URI via platform's share dialog (iOS only).
        
        Args:
            uri: URI to share.
        """
        args = {"uri": uri}
        return self.invoke_method("share_uri", args)