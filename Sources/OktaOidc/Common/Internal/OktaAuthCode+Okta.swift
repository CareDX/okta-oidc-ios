//
//  OktaAuthCode+Okta.swift
//  okta-oidc
//
//  Created by Shrey Shrivastava on 27/04/21.
//  Copyright © 2021 Okta. All rights reserved.
//

#if SWIFT_PACKAGE
import OktaOidc_AppAuth
#endif

// Okta Extension of OIDAuthState
extension OKTAuthState {

    static func getAuthCode(withAuthRequest authRequest: OKTAuthorizationRequest, delegate: OktaNetworkRequestCustomizationDelegate? = nil, callback: @escaping (String?, OktaOidcError?) -> Void ) {
        
        let finalize: ((String?, OktaOidcError?) -> Void) = { authCode, error in
            callback(authCode, error)
        }

        // Make authCode request
        OKTAuthorizationService.perform(authRequest: authRequest, delegate: delegate, callback: { authResponse, error in
            guard let authResponse = authResponse else {
                finalize(nil, OktaOidcError.APIError("Authorization Error: \(error?.localizedDescription ?? "No authentication response.")"))
                return
            }

            guard let authCode = authResponse.authorizationCode else {
                    finalize(nil, OktaOidcError.unableToGetAuthCode)
                    return
            }

            finalize(authCode, nil)
        })
    }
}
