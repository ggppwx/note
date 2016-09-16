import poplib
from email import parser
import re

poplib._MAXLINE=20480
ADDR = 'pop-mail.outlook.com'
USER_NAME = "sirgujingwei@hotmail.com"
PASSWORD = "ggppwx1016"

class Inbox:
    _pop_conn = None
    _server_addr = None
    _username = None
    _password = None
    
    def __init__(self, addr, username, password):
        self._server_addr = addr
        self._username = username
        self._password = password
        
    def connect(self):
        self._pop_conn = poplib.POP3_SSL(self._server_addr, 995)
        self._pop_conn.user(self._username)
        self._pop_conn.pass_(self._password)
    
    def close(self):
        self._pop_conn.quit()

    def receive_latest_mail(self, limit):
        msgs = []
        counter = 0
        for i in range(len(self._pop_conn.list()[1]), 1, -1):
            if counter == limit:
                break
    
            counter += 1
    
            msg = "\n".join(self._pop_conn.retr(i)[1])
            # print msg[0]

            msgobj = parser.Parser().parsestr(msg)

            subject = msgobj['subject']

            pattern = re.compile("^\w+@ORG$")
            result = pattern.match(subject)
            if result:        
                if not msgobj.is_multipart():
                    body = msgobj.get_payload()
                    
                    for line in body.splitlines():
                        if line.strip():
                            # print line
                            pattern = re.compile("^\*\s(.+)")
                            result = pattern.match(line)
                            if result:
                                todo = result.group(1)

                                # adding to org inbox 
                                msgs.append(todo)

                    # delete the mail
                    self._pop_conn.dele(i)
        return msgs    


def main():
    inbox = Inbox(ADDR, USER_NAME, PASSWORD )
    inbox.connect()
    todos = inbox.receive_latest_mail(10)
    inbox.close()
    
    print todos

    # parse todos 
    with open('scratch.org', 'a') as f:
        for todo in todos:
            text = " ".join(["** TODO", todo, "\n"])
            f.write(text)



if __name__ == '__main__':
    main()


                
            

