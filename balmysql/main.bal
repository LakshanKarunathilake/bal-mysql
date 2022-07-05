import ballerina/log;
import ballerina/http;

// final http:Client greetingsEp = check new ("http://bal-app.user1.svc.cluster.local:9090");
final http:Client echoEp = check new ("https://postman-echo.com");

service / on new http:Listener(9091) {

    resource function get call() returns error? {
        // var err = greetingsEp->get("/greeting?name=aaa", targetType = http:Response);
        var err = echoEp->get("/get?foo1=bar1&foo2=bar2", targetType = http:Response);
        if (err is error) {
            return err;
        }
        log:printInfo("response code: " + err.statusCode.toString());
    }
}