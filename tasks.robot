*** Settings ***
Documentation       Template robot main suite.
Library    RPA.Email.ImapSmtp   smtp_server=smtp.gmail.com  smtp_port=587
Library    RPA.HTTP 
Library    RPA.FileSystem
Library    RPA.JSON
Library    RPA.Robocloud.Items
Task Setup  Authorize  account=velaryones@gmail.com  password=tvubycwiiqqludqm


*** Tasks ***
Task
    ${payload}=    Get Work Item Payload
    Example task    ${payload}[image]    ${payload}[title]    ${payload}[payload]

*** Keywords ***
Example task
    [Arguments]    ${image}    ${title}    ${payload}
    ${recipients}=      Get Email List
    #   ${recipients}=    Convert String to JSON    [{"email":"renatoalvarezdev@gmail.com","name":"Paolo"},{"email":"renatoalvarez96@gmail.com","name":"Renato"},{"email":"mauriciosauzatorrez666@gmail.com","name":"Mauricio"}] 
    FOR    ${recipient}    IN    @{recipients}
        Log    ${recipient}
        ${body}=    Email Template    ${recipient['name']}    ${image}    ${title}    ${payload}
        Send Message     sender=velaryones@gmail.com    
        ...    html=True
        ...    recipients=${recipient['email']}   
        ...    subject=${title}    
        ...    body=${body}
    END
Get Email List
    ${response}=    Get    https://renatoalvarezdev.com/emails
    Log   ${response.json()}
    Return From Keyword    ${response.json()}

Email Template
    [Arguments]    ${name}    ${image}    ${title}    ${payload}
    Log    ${name}
    Log    ${image}
    # ${body}=    Set variable    <h1>${name}</h1><img src="${image}"/><p>${payload}</p>
    ${html}=    Read File    template.html
    ${body}=    Replace Variables    ${html}
    Log      ${body}
    Return From Keyword    ${body}
