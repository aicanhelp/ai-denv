### 1、分合文件
分十份：
split -n 10 bigfile.txt smallfile_prefix_
cat smallfile_prefix_* > bigfile.txt

### 2、变量操作
#### （1）${varname:-word}   
  If varname exists and isn't null, return its value; otherwise return word.
  Purpose: Returning a default value if the variable is undefined.
  Example: ${count:-0} evaluates to 0 if count is undefined.
#### (2) ${varname:=word}   
If varname exists and isn't null, return its value; otherwise set it to word and then return its value. Positional and special parameters cannot be assigned this way.
Purpose: Setting a variable to a default value if it is undefined.
Example: ${count:=0} sets count to 0 if it is undefined.
#### (3) ${varname:?message}  
If varname exists and isn't null, return its value; otherwise print varname: followed by message, and abort the current command or script (non-interactive shells only). Omitting message produces the default message parameter null or not set.
Purpose: Catching errors that result from variables being undefined.
Example: {count:?"undefined!"} prints "count: undefined!" and exits if count is undefined.
#### (4) ${varname:+word}   
If varname exists and isn't null, return word; otherwise return null. 
Purpose: Testing for the existence of a variable.  
Example: ${count:+1} returns 1 (which could mean "true") if count is defined.
#### (5) ${varname:offset:length}   
Performs substring expansion.[5] It returns the substring of $varname starting at offset and up to length characters. The first character in $varname is position 0. If length is omitted, the substring starts at offset and continues to the end of $varname. If offset is less than 0 then the position is taken from the end of $varname. If varname is @, the length is the number of positional parameters starting at parameter offset.
Purpose: Returning parts of a string (substrings or slices).
Example: If count is set to frogfootman, ${count:4} returns footman. ${count:4:4} returns foot.

#### (6) ${variable#pattern}

If the pattern matches the beginning of the variable's value, delete the shortest part that matches and return the rest.

#### (7) ${variable##pattern}

If the pattern matches the beginning of the variable's value, delete the longest part that matches and return the rest.

#### (8) ${variable%pattern}

If the pattern matches the end of the variable's value, delete the shortest part that matches and return the rest.

#### (9) ${variable%%pattern}

If the pattern matches the end of the variable's value, delete the longest part that matches and return the rest.

#### (10) ${variable/pattern/string}${variable//pattern/string}

The longest match to pattern in variable is replaced by string. In the first form, only the first match is replaced. In the second form, all matches are replaced. If the pattern begins with a #, it must match at the start of the variable. If it begins with a %, it must match with the end of the variable. If string is null, the matches are deleted. If variable is @ or *, the operation is applied to each positional parameter in turn and the expansion is the resultant list.[6]


I want to do this scenario as following, is it correct?
(1) the CA is Let’s Encrypt, and setup a Vault as ICA
(2) Setup a cert-manager to request the CA certificate for Vault to become a ICA. 
    cert-manager save the ICA certificate to Vault and Vault use it become a ICA. 
    cert-manager automatically update the ICA certificate in Vault.
(3) In the other hand, the application request cert-manager for the certificate update, and actually cert-manager needs to request the ICA to generate the real certificate.
(4) Vault, cert-manager and the application all are installed in kubernetes cluster, and the application get the cert from kubernetes secret, so actually, the certificate generated for the application is saved in Vautl, but it is bound to a kubernete secret. 