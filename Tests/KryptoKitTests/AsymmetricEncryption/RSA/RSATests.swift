//
//  RSATests.swift
//  
//
//  Created by Lorenzo Limoli on 06/03/24.
//

import XCTest
import KryptoKit

class RSATests: XCTestCase {
    
    func expect<Err: Error & Equatable>(error: Err?, ofType: Err.Type, whileExecuting block: () throws -> Any, file: StaticString = #file, line: UInt = #line){
        let expectError = error != nil
        do{
            let result = try block()
            if expectError{
                XCTFail("Expected \(error!), got \(result) instead", file: file, line: line)
            }
            
        }catch let catchedError{
            guard expectError else{
                XCTFail("Expected nil, got \(catchedError) instead", file: file, line: line)
                return
            }
            XCTAssertEqual(error, catchedError as? Err, file: file, line: line)
        }
    }
    
}

extension RSATests {
    var privatePkcs8Base64: String{
        "MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAJ0sROX0jU3xxdQlrAkkykL8HIm0MIFEHSjAich15yOKP2wx7/aQe0jBLZDuJF0vSEfo18pFHPGn5NRWPitSinP8M60zQJObwzgu86Z5+5urRPwLCRZ11pnor03Q+CmgoW4J7apgeg8q/kqgB1gPFy35hmo5j1Pmtn7wjIxiCB8NAgMBAAECgYEAgu8SJo9n9/rl1yna+3MOnGbyTzUxAz7/G6fqIHk4KL9Ovo+LXFhYm+9ySj5ZRNfS2zT6L6MLzbUUSF/gQq7sbwgWsxKd6nzjozsO6SksgQgtjAA2Lm+ayPsWGflsblRZOq6SaU2JtfyFd+qEtkLyxqcBBJa7MPK2bz55sSaEpvECQQDuEg8TuF3qZZXXgnU7uOZjdxw0j2/lsr9IpE/TjQGKIfxaj5P3JsRReeWEDS3FEdoVjeuVxbT45gZ622I5BWQbAkEAqQKGNAJJfGhheIlPvW/X5plIJnC6qTrTygq0saIc2XMDcD+lsDo8la3v9ayzDyQZRRJhO0yYWv7h4fc9Gkwr9wJBAN+/RUBJdKrJksybJcddfdpZpb6YWJhPKIwDMasnyRyj2GLcsjoEy1mv8M/s+ulOX+MGITYAPJf4yHpLGcNxl6UCQFDKRBzYewhdXTqhaNzFeg9hdnvpp1D+Lf+G3pmLRP8tW5ds1WdIb22dl/d4dp/mQa4i+xe9pZbaAGBkL3FCuEECQCHmzjDBAc2V38BUVI61cHZgAZUdQZNgyWXf2OboKIjB3iaQe7UeY4zDjDDpnf+VpIZu79RS3pxctFrFWavrc6s="
    }

    var privatePkcs1Base64: String{
        "MIIEowIBAAKCAQEAsb5OZZAvM1VfP0J/YoWJOeWtyAUsnhtA35cRc8i98I/KYyGi4xAZ6GZMhIMh9rNcAl9XYcRG3/2rsRALqkT1obiiISkPiZhKH2YW6N85HpvgsdqfqsHapvYOhTTiNv7+CThUZth1S75BqdfvGmHqlZH0luWGpbI3TiNg10hPDFYHhHG3dMusZ+HxgkekaUfvFgay1oVQkkanoe/tSFUDtr6NnYNBUmSX0R35YI3feRPglzIcad+vRkdZ7q7qq1C7tt8RvbdJ+Oo+XnNogbQSE0hhcnqa7HkLrijML1ID/q7qX5TSnjYE7u7abnag1zWlfbdG7i2tUpyBbWmIfhBU2QIDAQABAoIBAGRt6RIN4/2XUVgHFL7wQNdL5WNNOSaks4UicKQBWwEf3fUhPk4Z/OmJU9bT2U7xjR1yDYeaRYmuZWKIdG7iw/96uXEPKE5QlCElp/AwoK+g19bmdq0fF5KbGR0/AkqczaEcCOSLjcscVzHGZr17cfbNH2xbiDb7ebBW4RMDMlb/GVo9BoBGTdW5VmrPTZta54NZBuihF417uLBGjeH5dvd2QJr7Sulgv9gRIOSubqmE11ZKy2yUpFac71yr8MHNK1f9aIUmloYgUTeF+pq4WNT3GtB5gxNTaMWtcOOQ9M0zeyAoWNJATSYwhADtLooIsO8RAkHA0CQ12WYV5sZJjAECgYEA9xMvFEb1B0aVB6sIB7sbEbdON4FXVg2AfEefVEvSbu5OKMfw2KtiAOrLs4Ar/zl2A6JcPgI5jx9KLshH3259YupvxrMRvhG42HrHLav0XBPzEu2rwe9XyUFGobbgUdAlwZ+sg5ucY4TF95P4RxhAlgtw5s6qf7WVrfzguzSrNBkCgYEAuCn7PtSKYGlbUd8P/YDx39RTgQ8wcD+XNoLKZTArvlNYw4KulpRt8dwDiZnCtVhF4NyKh4lYDdna7xqLSZVpzOEA6WFYhUZz3f0QY5dNHnLQS8w/d/Yob1AYTps4GwcrXvPYCrBL2Jfmh+RX/8uZocoBWAPy1DQOEuPzODFgPsECgYEAseBfzotfMIPCGykouNgdnt2HNDKr+8nwrIirznZf43kxT+7SGEsaXWqsiGhIRJDLw8YJ/qJ/aeiu8YtDIzpajvIU0spshZggqcmKx/i6DehW4VO2igKUAtI51YbhbEUcSY95Fa7cIlGebKVc42I0bVGDUMeMvDCwt/gMmvpKH1ECgYB428wvaoo5RUsRyqKSyglxy8TVQKOYNpNEycaLa3Z5m/b3r45l8ZjJjYqgxdCa9Ag/zlv3ILIxvNPJ8JCSRMS/GLZhcmoGZLrrZwVXZlbM8aoy5CKO1nOowVaCV6kVS7oxwTL5qMLNrLo0Wi1KCFKVc504Jrc4fcTyrrfSG80+wQKBgDogaa2tU9gld//C6IHU56Miu+BCn9KN/OLAmmFY6MrcXDeLORauePuzay1mFHH53ELosmtJXvqXl4tim3LKMQjVNQPwDmqQqECdZ79luWdQYYIfwEtkLnDEGwWakbO41ZYu1r1tjEz5LSZNdWXuppoKc3S7LP8SOL+F2Z+zrQXB"
    }

    var privateKeyPem: String{
        """
-----BEGIN RSA PRIVATE KEY-----
MIICXAIBAAKBgQCd4w95bo+s8MT7ptO4gSC6C8SDjQdy9ZzvdF1l9cNv2rsMuoP3
9hmUReHCbUkxFtJIL5xmzaEH68glACIx/+FrbsgvPM2UMrvLJ8MPfrmYH8sioGsE
YoWNRkw8GkuxDglbfix8iiZvZZAIkk/TZX4JLcoWQD6QqWvFVHiX4s0SjQIDAQAB
AoGAHWdE4Xt6nF12gdsuwMSjgKJiZZFlGr6tDFcicbOUQwd8IEG4A/y8BMYC5j+O
CutSHAlp2idfXudFLcbZl3As3ZWT14YF8jj4oFctghINCvFKKSyeZv5cfdaWwWBo
r0Z2BCWRmg4pb37V8iRyH2KOO8SSiFo13dUDuEfdlQTYum0CQQD3WQo/+KomVyoe
PsTvdZgdezYg7Eay49Zh5dkbcVYHT/kb250iG8GbCR91kAG1pl6OrDOp+c+pd3Ot
y14fVCdfAkEAo2jprFHbc5firA4nn+Ad/w8UkJ6cMaVGpzlwH1eKgrjo/UjY3f6w
N/HB/FZcO8u0NhFNOrVDUe8hxhmgfXvpkwJBALw5teMYh+LFUffSLGtNQYStznMf
Wm2nk+zLzHtls+G8qgTZCqp6FMq2FoqQG7zv7eUEhgxDXhPIIu+OYwHUOGECQHz4
umUAQW4ZBdECDknV8/rhxJ+Jvfi15t/zLI27vIGW+xDiSoEUzB4s9WePgIB2nL8Q
4lh40iByWwkPBk+RmaMCQBS2Nk7tPOQ4uFDvRutSlGJNp9rY/rfbXb/HhpoRsXgS
jC1FRuTZ6kPAhFWAOhup+Qe3PQhPegLC4PDCUxk7N7U=
-----END RSA PRIVATE KEY-----
"""
    }
    
    var publicKeyX509: String { """
MIIBCgKCAQEAsb5OZZAvM1VfP0J/YoWJOeWtyAUsnhtA35cRc8i98I/KYyGi4xAZ6GZMhIMh9rNcAl9XYcRG3/2rsRALqkT1obiiISkPiZhKH2YW6N85HpvgsdqfqsHapvYOhTTiNv7+CThUZth1S75BqdfvGmHqlZH0luWGpbI3TiNg10hPDFYHhHG3dMusZ+HxgkekaUfvFgay1oVQkkanoe/tSFUDtr6NnYNBUmSX0R35YI3feRPglzIcad+vRkdZ7q7qq1C7tt8RvbdJ+Oo+XnNogbQSE0hhcnqa7HkLrijML1ID/q7qX5TSnjYE7u7abnag1zWlfbdG7i2tUpyBbWmIfhBU2QIDAQAB
"""
    }
    
    var publicAns1: String{
        "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA3O7pUBs1/ljmKOMEZoZygAXTjvdleztUnMcAQmELsf5SfNvjx4Wdac9B1arwtmevUCOnovHO2Ly09vzy1MvHRB9okS9Wd9m3Xb1QrPnpLy9new/ivuYjprkTntOYNVwtbpNKynETzMiXwA/45SFitYayug8IBaIU6Yoz5Fn+JCdUfyaYscnDOdj9pJXxPiHNx9HsAeXJLhcYM0AHMH7b7uZoeNLR1HJJxX4+QxpF7kir86wT45z/KLuShgndTy27keN+nbFw1gYMOIZmug3XksB7HSmGDgcGRTdlSWsQtzi8dUP3M3rMT+Um5menXDvIDOWVFULD+tigXbojoBkUBQIDAQAB"
    }

    var publicPem: String{
        """
-----BEGIN PUBLIC KEY-----
MIGeMA0GCSqGSIb3DQEBAQUAA4GMADCBiAKBgE28gu6UODYFa03RfvIHOykBLEQM
zu1rqriA8NLxtqdgwPLyS42mE1IHvAzD+kJ3jsr+AYiSY1nHRiVLu76krJKij63N
DATpcFGjilwHwKSFfCn62rgEqY4v5xM+Qja6U+7KD/q31PTUPT3/X3FPvUDLqJBk
EhVC11/pvfQ6+8iZAgMBAAE=
-----END PUBLIC KEY-----
"""
    }
}

extension RSATests {
    var encryptionSuite: (privKey: String, pubKey: String, plainText: String, cipherText: String) {
        (
            privatePkcs1Base64,
            publicKeyX509,
            "This is a secret message",
            "gty1V0VRAX8Yd7B8vwoncSPq85P9rJ/keky8Lnu/rQbvKzi/7aFh8JEaVXrF3U2hiQXlhXYozt0tqz6CrXrws8az3CVa1JYF1cwRLEdOT27TW2aFfAbdjQDuESGEQTwCogmVvFEOo/HQB/rJApnRCWMjKbC31WowjziPM8un5eDoDVTnr8oeYiT5XTwVOastUtadFw3LVFxOcKOHCFsPT+jjZdFwNgsqPeZIb7iPSZZKc1a2X/2MIhkgNntHmKYy/xGeLUwtMrajUn0d/fw+nlopH/UX3wZYM1M7NvNC4PwiqNIIUx92SihNC6Iljwp4aym2T/kNul87X5e/9oX9sg=="
        )
    }
    
    var signatureSuite: (privKey: String, pubKey: String, document: String, signature: String) {
        (
            privatePkcs1Base64,
            publicKeyX509,
            "This is a document",
            "PRnu23pJhLeq5pWAxjHzucDa/dZPy75vbGH/F2yfwZKJZGRzLcyWfplWbEm3224lZrWGsGV4lXVMheoMvg1cARZmicFtqhFUMDvxu1mpfqWGCt+GlcTJvBfn1hwA0xM+bzs3SWuaNrhiDg4a4ArnoBReWw0dAhYeN06K0YuAX9RyhWqRSXHBbdOuBCoHTHoRRezla26K8djVl78NiK3UchNc2kNGUbGyGfABB7vAsNFcqPn6cbKPAkY3/Xt5ivIXOPVe+Fl2YbzVALEN0JOImvgKG7c80w0MFsAn4eP0PGhmrDzEk4UtsZubtnXqX0VbXioQM+yVE0ZcJAfdc/CCXA=="
        )
    }
}
