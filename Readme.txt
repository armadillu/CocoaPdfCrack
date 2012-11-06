This will try to unlock the user specified encripted pdf file with all the passwords found on a supplied wordlist. Work will be split in as many threads as the user specifies.

Because the PDFDocument class is not thread safe, once a password is found to be correct is hard to figure out which thread found it, so the last user password per thread is displayed. One of them should be the correct one, usually the last one on my setup.

usage: CocoaPdfCrack file.pdf dictionary.txt numThreads

uses LineReader class by Dave DeLong found https://github.com/johnjohndoe/LineReader#readme