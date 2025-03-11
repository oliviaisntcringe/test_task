from burp import IBurpExtender, IScannerCheck, IScanIssue
import java.io.PrintWriter

class BurpExtender(IBurpExtender, IScannerCheck):
    def registerExtenderCallbacks(self, callbacks):
        self._callbacks = callbacks
        self._helpers = callbacks.getHelpers()
        self._stdout = PrintWriter(callbacks.getStdout(), True)
        callbacks.setExtensionName("Open Redirect Scanner")
        callbacks.registerScannerCheck(self)
        self._stdout.println("Open Redirect Scanner загружен")

    def doActiveScan(self, baseRequestResponse, insertionPoint):
        test_payload = "https://malicious.com"
        new_request = insertionPoint.buildRequest(test_payload)
        attack_response = self._callbacks.makeHttpRequest(baseRequestResponse.getHttpService(), new_request)
        analyzed_response = self._helpers.analyzeResponse(attack_response.getResponse())
        headers = analyzed_response.getHeaders()

        for header in headers:
            if header.startswith("Location:") and "https://malicious.com" in header:
                return [CustomScanIssue(
                    baseRequestResponse.getHttpService(),
                    self._helpers.analyzeRequest(baseRequestResponse).getUrl(),
                    [attack_response],
                    "Open Redirect Vulnerability",
                    "Приложение позволяет перенаправление на недопустимый URL.",
                    "High")]
        return None
