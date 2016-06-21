//
//  ViewController.swift
//  SnapOnboarding-iOS
//
//  Created by Gaute Solheim on 13.06.2016.
//  Copyright © 2016 Gaute Solheim. All rights reserved.
//

import UIKit
import SnapFonts_iOS
import SnapTagsView

class ViewController: UIViewController {
    
    private var didPresent = false
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !didPresent {
            didPresent = true
            presentOnboardingViewController()
        }
    }
    
    private func presentOnboardingViewController() {
        let storyboard = UIStoryboard(name: "SnapOnboarding", bundle: nil)
        let onboardingViewController = storyboard.instantiateViewControllerWithIdentifier("snapOnboardingViewController") as! SnapOnboardingViewController
        
        let stringsViewModel = createSampleStringsViewModelEnglish()
        
        let configuration = SnapOnboardingConfiguration(delegate: self, stringsViewModel: stringsViewModel)
        
        onboardingViewController.applyConfiguration(configuration)
        
        presentViewController(onboardingViewController, animated: false, completion: nil)
    }
    
    private func createSampleStringsViewModelNorwegian() -> SnapOnboardingStringsViewModel {
        var model = SnapOnboardingStringsViewModel()
        
        let footer = "Ved bruk av tjenesten Snapsale godtar du Vilkårene for bruk og Retningslinjer for personvern"
        model.termsAndPrivacyFooter = footer
        model.rangeOfTermsAndConditions = footer.rangeOfString("Vilkårene for bruk")
        model.rangeOfPrivacyPolicy = footer.rangeOfString("Retningslinjer for personvern")
        
        model.next = "Neste"
        model.introHeadline = "Å legge ut salg er raskt og enkelt. Vi tagger og kategoriserer annonser med smart bildegjenkjenning."
        model.tags = createTagRepresentationsFromStrings(
            ["Veske", "MichaelKors", "JetSetTravel", "Skinn", "Beige", "Accessoirer"]
        )
        
        model.locationHeadline = "Følg selgere og produkter nær deg! Aldri gå glipp av et kupp igjen."
        model.enableLocationServices = "Skru på stedstjenester"
        model.notNow = "Ikke nå"
        model.willAskLaterTitle = "Den er god!"
        model.willAskLaterBody = "Vi vil spørre deg på et senere tidspunkt, når vi trenger lokasjonen din, for eksempel ved et nytt salg."
        model.wowYouDeclinedTitle = "Oi, du avslo stedstjenester!"
        model.wowYouDeclinedBody = "Om du ønsker å skru det på senere, gå til: System innstillinger › Personvern › Stedstjenester › Snapsale"
        model.continueWithFacebook = "Fortsett med Facebook"
        model.continueWithInstagram = "Fortsett med Instagram"
        model.skipWithoutLogin = "Hopp over, prøve uten innlogging"
        
        return model
    }
    
    private func createSampleStringsViewModelEnglish() -> SnapOnboardingStringsViewModel {
        var model = SnapOnboardingStringsViewModel()
        
        let footer = "You accept our Privacy Policy and Terms And Conditions by using the service Snapsale."
        model.termsAndPrivacyFooter = footer
        model.rangeOfTermsAndConditions = footer.rangeOfString("Terms And Conditions")
        model.rangeOfPrivacyPolicy = footer.rangeOfString("Privacy Policy")
        
        model.next = "Next"
        model.introHeadline = "Publishing sales is fast and easy. We tag and categorise ads with clever image recognition."
        model.tags = createTagRepresentationsFromStrings(
            ["Purse", "MichaelKors", "JetSetTravel", "Leather", "Beige", "Accessories"]
        )
        
        model.locationHeadline = "Follow sellers and products near you! Never miss a bargain again."
        model.enableLocationServices = "Enable location services"
        model.notNow = "Not now"
        model.willAskLaterTitle = "All right!"
        model.willAskLaterBody = "We will ask again later, when we need your location, for instance when you publish an ad."
        model.wowYouDeclinedTitle = "Wow, you disabled location services!"
        model.wowYouDeclinedBody = "If you wish to enable it later, navigate to: System settings › Privacy › Location Services › Snapsale."
        model.continueWithFacebook = "Continue with Facebook"
        model.continueWithInstagram = "Continue with Instagram"
        model.skipWithoutLogin = "Skip, try without logging in."
        
        return model
    }
    
    private func createTagRepresentationsFromStrings(strings: [String]) -> [SnapTagRepresentation] {
        var snapTagRepresentations = [SnapTagRepresentation]()
        strings.forEach { tag in
            let tagRepresentation = SnapTagRepresentation()
            tagRepresentation.tag = tag
            snapTagRepresentations.append(tagRepresentation)
        }
        return snapTagRepresentations
    }

}

extension ViewController: SnapOnboardingDelegate {
    
    func termsAndConditionsTapped() {
        print("terms-and-conditions-tapped")
    }
    
    func privacyPolicyTapped() {
        print("privacy-policy-tapped")
    }
    
    
    func enableLocationServicesTapped() {
        print("enable-location-services-tapped")
    }
    
    
    func facebookSignupTapped() {
        print("facebook-signup-tapped")
    }
    
    func instagramSignupTapped() {
        print("instagram-signup-tapped")
    }
    
    
    func willDismiss() {
        print("will-dismiss")
    }
    
    func didDismiss() {
        print("did-dismiss")
    }
    
}