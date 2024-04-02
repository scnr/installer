#!/usr/bin/env bash

cat<<EOF
                      Codename SCNR installer
-------------------------------------------------------------------------

EOF

if (( UID == 0 )); then
    echo "Cannot run as root!"
    exit 1
fi

#
# Checks the last return value and exits with an error message on failure.
#
# To be called after each step.
#
handle_failure() {
    rc=$?
    if [[ $rc != 0 ]] ; then
        echo "Installation failed, check $log for details."
        exit $rc
    fi
}

operating_system(){
    uname -s | awk '{print tolower($0)}'
}

architecture(){
    uname -m
}

version() {
    echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }';
}

print_eula() {
    less --prompt="Hit SPACE to move to next page" --quit-at-eof <<EOF
Codename SCNR Terms & Conditions of Supply

IMPORTANT NOTICE: PLEASE READ THE FOLLOWING TERMS BEFORE ORDERING OR DOWNLOADING ANY SOFTWARE FROM THIS WEBSITE AS APPLICABLE TO THE LICENCE AND USE OF THAT SOFTWARE.

These Codename SCNR Terms & Conditions of Supply together with the documents referred to in it ("Terms") constitute the terms and conditions on which Ecsypno Single Member P.C. ("Licensor") will grant to any purchaser or user ("Licensee") a licence to use the software comprising Codename SCNR ("Codename SCNR" or the "Software"), following acceptance of an order as detailed below.

The following expressly form part of the Terms:

- The Codename SCNR License Agreement;

- The General Terms and Conditions;

- The Privacy Policy; and

- Any other documents referred to in the above.

The Terms apply to the exclusion of any other terms that the Licensee seeks to impose or incorporate, or which are implied by trade, custom, practice or course of dealing.

1. Licenses to Codename SCNR are available for purchase via the Licensor's website at https://ecsypno.com/products/scnr.

2. Placing an order for Codename SCNR or checking "I have read and accept the terms and conditions" on a webform is an offer by the Licensee to purchase a licence to the Software and does not constitute a contract until such time as the Licensor issues an email or web confirmation that the order is accepted by Ecsypno Single Member P.C..  Notwithstanding the foregoing, by installing the Software the Licensee affirms that it agrees to the terms of the License and the Codename SCNR terms and conditions of supply, which bind the Licensee and its employees.  The contract will only relate to the Software the Licensee has licensed, as set out in that confirmation or accepted by installing it.  Notwithstanding any other communications between the parties, ordering and/or downloading the Software by the Licensee, or the download of the Software by another party at the instigation of the Licensee, shall constitute conclusive evidence that the Licensee has purchased the Software on the basis of these Terms & Conditions of Supply and Ecsypno Single Member P.C.'s order quotation.

3. Unless Ecsypno Single Member P.C. has pre-approved the Licensee's purchase on credit in writing (and subject to any additional credit terms that apply to any such approval), payment is required in advance. Shortly after the Licensee makes payment and the order has been accepted by Ecsypno Single Member P.C., the Licensee will receive an email containing instructions enabling the Licensee to log in and download the Licensee's software and licence key.  If the Licensee does not receive this email within 30 minutes of making payment, please email the Licensor, who will investigate the issue and endeavour to respond within one working day. In relation to purchases made on agreed credit terms, Ecsypno reserves the right to charge interest under the Late Payment of Commercial Debts (Interest) Act 1998 on invoiced amounts unpaid by their due date.

4. If the Licensee's license is subject to auto-renewal and the Licensee has provided a valid recurring payment method, then payment will be taken 14 days before the expiry of the then current License Period (as defined in the Codename SCNR License Agreement) ("Renewal Payment Date"). Auto-renewal for specific licences can be disabled on the Licensee's account page.

5. If the Licensee wishes to cancel its order, please email the Licensor, within 7 days of making payment or payment being taken for auto-renewal licenses, or if the order has been placed on credit, credit having been pre-approved by Ecsypno Single Member P.C., please email the Licensor within 7 days of placing the order, and in each case before the Licensee downloads the software or licence key.  If the Licensee already downloaded the software or licence key, it will not be possible to refund the order.

6. If the Licensee's payment is subject to any tax liability within any jurisdiction (for example, withholding tax) then it bears sole responsibility for meeting this liability, and no deductions must be made in the amount paid to Ecsypno Single Member P.C..  Ecsypno Single Member P.C. does not accept liability for any tax liabilities that may arise from the Licensee's purchase of the Software or any associated services hereunder.

7. When the contract for the purchase of Codename SCNR has been concluded, such contract is made for the benefit of the Licensee and Ecsypno Single Member P.C. only and is not intended to benefit, or be enforceable by, anyone else.

8. These Terms (including all the documents referred to in them) are governed by and construed in accordance with Greek Law and submitted to the exclusive jurisdiction of the Greek courts.

Codename SCNR License Agreement

This licence agreement which incorporates the General Terms and Conditions below ("License") forms part of the Terms for the Software, which includes computer software, and the online documentation current at the date of the download of this License and accessible on https://documentation.ecsypno.net/ ("Documentation").

THE DOCUMENTATION CONTAINS THE SYSTEM REQUIREMENTS TO RUN CODENAME SCNR.  INTERNET ACCESS IS REQUIRED DURING INSTALLATION TO ACTIVATE THE SOFTWARE.

IF THE LICENSEE DOES NOT AGREE TO THE TERMS OF THE LICENCE AND THE CODENAME SCNR TERMS AND CONDITIONS OF SUPPLY, THE LICENSOR IS UNWILLING TO LICENSE THE SOFTWARE TO THE LICENSEE AND (1) THE LICENSEE MUST DISCONTINUE ANY ON-GOING ORDERING PROCESS NOW AND MUST NOT INSTALL THE SOFTWARE; AND/OR (2) WHERE THE SOFTWARE HAS ALREADY BEEN INSTALLED, THE LICENSEE MUST CEASE USING IT IMMEDIATELY.

WARNING: CODENAME SCNR IS DESIGNED TO TEST FOR SECURITY FLAWS AND CAN DO DAMAGE TO TARGET SYSTEMS DUE TO THE NATURE OF ITS FUNCTIONALITY.  TESTING FOR SECURITY FLAWS INHERENTLY INVOLVES INTERACTING WITH TARGETS IN NON-STANDARD WAYS WHICH CAN CAUSE PROBLEMS IN SOME VULNERABLE TARGETS.  THE LICENSEE MUST TAKE DUE CARE WHEN USING THE SOFTWARE, MUST READ ALL DOCUMENTATION BEFORE USE AND BACK UP TARGET SYSTEMS BEFORE USE.  WHERE THE LICENSEE USES THE SOFTWARE ON PRODUCTION SYSTEMS OR OTHER SYSTEMS, IT EXPRESSLY HEREBY ACCEPTS THE RISK OF DAMAGE AND RISK OF LOSS OF DATA OR LOSS OF USE IN RESPECT OF SUCH DATA AND SYSTEMS AND ACCEPTS THAT IT SHOULD NOT USE THE SOFTWARE ON ANY SYSTEMS FOR WHICH IT DOES NOT ACCEPT THE RISK OF DAMAGE, RISK OF LOSS OF DATA OR LOSS OF USE.

1. GRANT AND SCOPE OF LICENCE

1.1. In consideration of the payment by the Licensee of any agreed licence fee and the Licensee agreeing to abide by the terms of the License, the Licensor hereby grants to the Licensee a non-exclusive, non-transferable licence for the period (the "License Period") specified in the Licensee's order confirmation for the number of individual users specified therein to use the Software and the Documentation on the terms of the License.

1.2. If the License is subject to auto-renewal, a new License Period will commence on the expiry of the previous License Period, subject to successful payment being taken on the Renewal Payment Date. Each subsequent License Period commenced using the auto-renew process will be for the same duration as the previous License Period , unless the Licensor has agreed otherwise with the Licensee in writing.

1.3. Each installation of Codename SCNR on an individual computer needs to be activated before it will operate, including subsequent Licenses commenced using auto-renewal. It is recognised that in the course of ordinary usage of the Software, individual users may need to install the product on more than one computer. The number of activations performed for each licence is monitored. The Licensor reserves the right to limit the number of activations allowed per licence, and to prevent further activations if this limit is exceeded.

1.4. The Licensee may:

1.4.1. download, install and use the Software (as defined in General Terms and Conditions, section 5) for its internal business purposes (which may, include the provision of a bespoke consultancy service to clients where the Licensee is acting in a business advisory capacity) only;

1.4.2. make one copy of the Software for back-up purposes only, provided that this is necessary for the activities permitted under section 1.4.1;

1.4.3. receive and use any free supplementary software code or update of the Software incorporating "patches" and corrections of errors as may be provided by the Licensor from time to time on the basis that they are governed by the terms of the License;

1.4.4. use any Documentation in support of the use permitted under section 1.4.1 and make such numbers of copies of the Documentation as are reasonably necessary for its lawful use; and

1.4.5. analyse the behaviour and performance of the documented functionality of the Software and disclose the findings of such analysis to any party provided that such findings are provided simultaneously and in identical form to the Licensor; and

1.4.6. resell the Software, provided that:

1.4.6.1. the Licensee procures that the purchaser is bound by the terms of this License for the benefit of the Licensor, with an ability for the Licensor to enforce such terms against the purchaser directly and that the Licensee indemnify the Licensor against all costs (including legal costs) charges and expenses incurred by the Licensor as a result of the failure by the Licensee to comply with the provisions of this paragraph and/or the resale by the Licensee of the Software to the purchaser; and

1.4.6.2. the Licensee has purchased the Software directly from the Licensor.

1.5. If the Licensee is a purchaser who has lawfully obtained the Software other than by direct purchase from the Licensor, the Licensee may carry out the activities specified in sections 1.4.1 to 1.4.5 above and, in consideration of the Licensor agreeing to provide updates of the Software to the Licensee during the License Period, either directly or via the relevant intermediary or intermediaries, the Licensee agree to be bound by the License directly in favour of the Licensor.

2. LICENSEE'S WARRANTY AND UNDERTAKINGS

In addition to the warranties and undertakings given in the General Terms and Conditions, the Licensee undertakes to keep confidential any credentials provided by the Licensor enabling the Licensee to log in to the Licensor's server (for the purposes of downloading product builds and licence keys and to perform product activation.

3. LICENSOR'S LIABILITY: ATTENTION IS DRAWN PARTICULARLY TO THE PROVISIONS OF THIS CONDITION

Subject to the General Terms and Conditions, section 9.1, the Licensor's maximum aggregate liability under or in connection with this License, or any collateral contract, whether in contract, tort (including negligence) or otherwise, shall be limited to a sum equal to 125% (one hundred and twenty five per cent) of the average annual License Fee due under the License.

GENERAL TERMS AND CONDITIONS

These terms and conditions are applicable to and form part of the Terms entered into between the Licensee and the Licensor for the Software and apply, unless specified or the context otherwise requires, whether the Software has been acquired either directly or indirectly by way of free download, pre-purchase or purchase on credit, free trial or by way of free licence for training purposes.  Unless the context otherwise requires words and expressions used in the remainder of the Terms shall have the same meanings when used in these terms and conditions.

1. LICENSEE'S WARRANTY AND UNDERTAKINGS

1.1. The Licensee warrants that it is not purchasing licences to the Software as a consumer, but will be using the Software in its business and that any users placing orders for the Software and/or accepting these Terms are duly authorised by the Licensee to acquire licences to the Software.

1.2. Except as expressly set out in the License or as permitted by any local law, the Licensee undertakes:

1.2.1. not to use (or allow to be used) the Software, the Documentation for any unlawful purposes, particularly as the Software contains functionality that can be used to attack and compromise computer systems, and the Licensee shall be responsible for all losses, costs, liabilities or other damages incurred by the Licensor in connection with any claim by a third party in connection with a breach by the Licensee of this obligation;

1.2.2. to keep confidential any credentials provided by the Licensor enabling the Licensee to log in to the Licensor's server (for the purposes of downloading product builds and licence keys and to perform product activation;

1.2.3. to obtain all necessary authorisations from system owners prior to using the Software;

1.2.4. unless agreed by the Licensor not to copy the Software or Documentation except where such copying is incidental to normal use of the Software, or where it is necessary for the purpose of back-up or operational security;

1.2.5. subject to the provisions of section 5, not to rent, lease, sub-license, loan, translate, merge, adapt, vary or modify the Software or Documentation;

1.2.6. subject to the provisions of section 5, not to make alterations to, or modifications of, the whole or any part of the Software, nor permit the Software or any part of it to be combined with, or become incorporated in, any other programs;

1.2.7. not to disassemble, decompile, reverse engineer or create derivative works based on, the whole or any part of the Software nor attempt to do any such thing except to the extent that (by virtue of section 296A of the Copyright, Designs and Patents Act 1988) such actions cannot be prohibited because they are essential for the purpose of achieving inter-operability of the Software with another software program, and provided that the information obtained by the Licensee during such activities:

1.2.7.1. is used only for the purpose of achieving inter-operability of the Software with another software program; and

1.2.7.2. is not unnecessarily disclosed or communicated without the Licensor's prior written consent to any third party; and

1.2.7.3. is not used to create any software which is substantially similar to the Software;

1.2.8. to supervise and control use of the Software and ensure that the Software is used by the Licensee's employees and representatives in accordance with the terms of the License;

1.2.9. to replace the current version of the Software with any updated or upgraded version or new release provided by the Licensor to the Licensee via its account or the Software, immediately on receipt (and failure to do so may result in the Licensee's ineligibility for support pursuant to this Agreement);

1.2.10. to keep all copies of the Software secure and to maintain accurate and up-to-date records of the number of locations of all copies of the Software;

1.2.11. to include the copyright notice of the Licensor on all entire and partial copies the Licensee makes of the Software on any medium;

1.2.12. not to provide or otherwise make available the Software in whole or in part (including but not limited to program listings, object and source program listings, object code and source code), in any form to any person other than the Licensee's employees without prior written consent from the Licensor;

1.2.13. unless specifically authorised by the Licensor in writing, not to use the Software as part of an automated service offering to third parties;

1.2.14. not to engage in any activity, practice or conduct which would constitute an offence under sections 1, 2 or 6 of the Bribery Act 2010, if such activity, practice or conduct had been carried out in the UK; and

1.2.15. to be responsible for all liability claims, actions, or causes of action, together with the legal costs of the Licensor in bringing the same, arising by reason of or in any way relating to the Licensee's actions or activities of its employees, agents, or contractors under the License.

2. SUPPORT AND UPGRADES

2.1. The downloading of a licence for the Software entitles the Licensee to free product support provided via the Licensor's support centre portal on its website at the Licensor's sole discretion.  Such support will be subject to any support conditions, guidance or FAQs on https://documentation.ecsypno.com/ from time to time.

2.2. If licences to new releases of the Software are offered for sale to the Licensor's customers generally, these may be made available free of charge to the Licensee for the duration of the License provided that the Licensee enters into a new licence agreement in respect of such new release on such terms as may be notified to the Licensee by the Licensor at that time.  If no such new licence terms are notified, these terms shall continue to apply.

6. THIRD PARTY SOFTWARE

The Software may make use of third party technology that is provided with the Software.  The Licensor may provide certain notices to the Licensee in the Documentation, readmes or notice files in connection with such third party technology.  Third party technology will be licensed to the Licensee either under the terms of this License or, if specified in the Documentation, readmes or notice files, under separate terms or as otherwise notified to the Licensor by the Licensee.

7. INTELLECTUAL PROPERTY RIGHTS

7.1. The Licensee acknowledges that all intellectual property rights in the Software and the Documentation anywhere in the world belong to the Licensor, that rights in the Software are licensed (not sold) to the Licensee, and that the Licensee has no rights in, or to, the Software or the Documentation other than the right to use them in accordance with the terms of the License.

7.2. The Licensee acknowledges that it has no right to have access to the Software in source code form.

7.3. The integrity of this Software is protected by technical protection measures ("TPM") so that the intellectual property rights, including copyright, in the Software of the Licensor are not misappropriated.  The Licensee must not attempt in any way to remove or circumvent any such TPM, nor apply or manufacture for sale or hire, import, distribute, sell or let for hire, offer or expose for sale or hire, advertise for sale or hire or have in its possession for private or commercial purposes any means the sole intended purpose of which is to facilitate the unauthorised removal or circumvention of such TPM.

7.4. The Licensor will defend Licensee against any claim, demand, suit or proceeding made or brought against Licensee by a third party alleging that any Software or services infringe or misappropriate such third party's intellectual property rights (a "Third Party IPR Claim"), and will indemnify Licensee from any direct damages, finally awarded against Licensee as a result of, or for amounts paid by Licensee under a settlement approved by Licensor in writing of, a Third Party IPR Claim, provided that, in each case the Licensee:

7.4.1. promptly gives Licensor written notice of the Third Party IPR Claim;

7.4.2. gives the Licensor, at its sole option, the sole control of the defence and settlement of the Third Party IPR Claim; and

7.4.3. gives Licensor all reasonable assistance, at Licensor's expense.

If Licensor receives information about an infringement or misappropriation claim related to the Software or services, Licensor may in its discretion and at no cost to Licensee (i) modify the Software or services so that they are no longer claimed to infringe or misappropriate, (ii) obtain a license for Licensee's continued use of the Software or services in accordance with this Agreement, or (iii) terminate Licensee's subscriptions for such Software or services upon 30 days' written notice and refund Licensee any prepaid fees covering the remainder of the term of the terminated licence.  The above defence and indemnification obligations do not apply if (1) the allegation does not state with specificity that the Software or services are the basis of the Third Party Claim; (2) a Third Party Claim arises from the use or combination of the Software or services or any part thereof with software, hardware, data, or processes not provided by Licensor, if the Software or Services or use thereof would not infringe without such combination; (3) a Third Party Claim arises from Software or services for which there is no charge or has been provided on a free trial or community licence basis; or (4) a Third Party Claim arises from the Licensee's or a third party's materials or application or Licensee's breach of this Agreement.  This clause provides the Licensor's sole liability to, and the Licensee's exclusive remedy against, the Licensor for any Third Party IPR Claim.

8. LICENSOR'S WARRANTY

8.1. The Licensor warrants that for a period of 90 days from the date of purchase of the Software (Warranty Period) the Software will, when properly used, perform substantially in accordance with the functions described in the Documentation (provided that the Software is properly used on the computer and with the runtime environment for which it was designed as referred to in the Documentation). This clause 8.1 does not apply in respect of Software for which there is no charge or has been provided on a free trial or community licence basis.

8.2. The Licensee acknowledges that the Software is provided "as is" and have not been developed to meet its individual requirements, and that it is therefore the Licensee's responsibility to ensure that the facilities and functions of the Software as described in the Documentation.

8.3. The Licensee acknowledges that the Software may not be free of bugs or errors, and agree that the existence of minor errors shall not constitute a breach of the License.

8.4. If, within the Warranty Period, the Licensee notifies the Licensor in writing of any defect or fault in the Software in consequence of which it fails to perform substantially in accordance with the Documentation, and such defect or fault does not result from the Licensee having amended the Software or used it in contravention of the terms of the License, the Licensor will, at its sole option, either repair or replace the Software, provided that the Licensee make available all the information that may be necessary to help the Licensor to remedy the defect or fault, including sufficient information to enable the Licensor to recreate the defect or fault.

9. LICENSOR'S LIABILITY: ATTENTION IS DRAWN PARTICULARLY TO THE PROVISIONS OF THIS CONDITION

9.1. Nothing in the License shall limit or exclude the liability of either party for death or personal injury resulting from negligence, fraud, fraudulent misrepresentation or any other liability that cannot be limited by law.

9.2. Subject to section 9.1, the Licensor's liability for losses suffered by the Licensee arising out of or in connection with the License (including any liability for the acts or omissions of its employees, agents and subcontractors), whether arising in contract, tort (including negligence), misrepresentation or otherwise, shall not include liability for:

9.2.1. loss of turnover, sales or income;

9.2.2. loss of business profits or contracts;

9.2.3. business interruption;

9.2.4. loss of the use of money or anticipated savings;

9.2.5. loss of information;

9.2.6. loss of opportunity, goodwill or reputation;

9.2.7. loss of, damage to or corruption of software or data; or

9.2.8. any indirect or consequential loss or damage of any kind howsoever arising and whether caused by tort (including negligence), breach of contract or otherwise.

9.3. The License sets out the full extent of the Licensor's obligations and liabilities in respect of the supply of the Software.  In particular, there are no conditions, warranties, representations or other terms, express or implied, that are binding on the Licensor except as specifically stated in the License.  Any condition, warranty, representation or other term concerning the supply of the Software which might otherwise be implied into, or incorporated in, the License, or any collateral contract, whether by statute, common law or otherwise, is hereby excluded to the fullest extent permitted by law.

10. PUBLICITY AND COMMUNICATION

10.1. By entering into the License the Licensee agrees that the Licensor may refer to the Licensee as one of its customers internally and in externally published media and, where relevant, the Licensee grants its consent to the use of the Licensee's logo(s) for this purpose, unless the Licensee notifies the Licensor in writing that the Licensor may not refer to it for such purpose.  Any additional disclosure by the Licensor with respect to the Licensee shall be subject to its prior written consent.

10.2. By entering into the License, the Licensee consents that the Licensor may process the personal data that it collects from the Licensee in accordance with the Licensor's Privacy Policy.  The Licensee is responsible for ensuring it has in place all relevant consents, permissions or rights to share any personal data with the Licensor for the Licensor's use in accordance with the Privacy Policy and these Terms.  In particular, the Licensor may use information it holds about the Licensee or its designated contacts for the purposes of, inter alia, sending out renewal reminders, questionnaires to certain categories of users including non-renewers and feedback requests.

10.3. Any questions, comments and requests regarding the Licensor's data processing practices may be addressed to contact@ecsypno.com.

11. TERMINATION

11.1. The Licensor may terminate the License immediately by written notice to the Licensee if the Licensee or any of its users commit a material or persistent breach of the License, including without limitation, any failure to make any payment due to the Licensor by its due date, which the Licensee fails to remedy (if remediable) within 14 days after the service of written notice requiring the Licensee to do so.

11.2. Upon termination for any reason:

11.2.1. all rights granted to the Licensee under the License shall cease;

11.2.2. the Licensee must cease all activities authorised by the License;

11.2.3. the Licensee must immediately delete or remove the Software from all computer equipment in its possession, and immediately destroy or return to the Licensor (at the Licensor's option) all copies of the Software then in its possession, custody or control and, in the case of destruction, certify to the Licensor that it have done so; and

11.2.4. the Licensee must immediately pay to the Licensor any sums due to the Licensor under the License.

12. TRANSFER OF RIGHTS AND OBLIGATIONS

12.1. The License is binding on the Licensee and the Licensor, and each of their respective successors and assigns.

12.2. The Licensee may not transfer, assign, charge or otherwise dispose of the License, or any of its rights or obligations arising under it, without the Licensor's prior written consent.

12.3. Where Licensee is a company, the licenses granted hereunder shall also extend to the Licensee's Group members (meaning, in relation to any company, that company, its subsidiaries, its ultimate holding company and all subsidiaries of such ultimate holding company, as such terms are defined in the Companies Act 2006), provided that such Group members have no right under the Contracts (Rights of Third Parties) Act 1999 to enforce any term of the Agreement.

12.4. The Licensor may transfer, assign, charge, sub-contract or otherwise dispose of the License, or any of the Licensor's rights or obligations arising under it, at any time during the term of the License.

13. NOTICES

All notices given by the Licensee to the Licensor must be given to Ecypno Single Member P.C. at contact@ecsypno.com or Ippokratous 10, Mandra, Attika, 19600, Greece. The Licensor may give notice to the Licensee at either the e-mail or postal address the Licensee provided to the Licensor when purchasing the Software, or if the Licensee has updated their account details on the website following the purchase of the Software, these details shall be used.  Notice will be deemed received and properly served immediately when posted on the Licensor's website, 24 hours after an e-mail is sent, or three days after the date of posting of any letter.  In proving the service of any notice, it will be sufficient to prove, in the case of a letter, that such letter was properly addressed, stamped and placed in the post and, in the case of an e-mail, that such e-mail was sent to the specified e-mail address of the addressee.

14. EVENTS OUTSIDE LICENSOR'S CONTROL

14.1. The Licensor will not be liable or responsible for any failure to perform, or delay in performance of, any of the Licensor's obligations under the License that is caused by events outside its reasonable control ("Force Majeure Event").

14.2. A Force Majeure Event includes any act, event, non-happening, omission or accident beyond the Licensor's reasonable control and includes in particular (without limitation) the following:

14.2.1. strikes, lock-outs or other industrial action;

14.2.2. civil commotion, riot, invasion, terrorist attack or threat of terrorist attack, war (whether declared or not) or threat of or preparation for war;

14.2.3. fire, explosion, storm, flood, earthquake, subsidence, epidemic or other natural disaster;

14.2.4. impossibility of the use of railways, shipping, aircraft, motor transport or other means of public or private transport;

14.2.5. impossibility of the use of public or private telecommunications networks; and

14.2.6. the acts, decrees, legislation, regulations or restrictions of any government.

14.3. The Licensor's performance under the License is deemed to be suspended for the period that the Force Majeure Event continues, and the Licensor will have an extension of time for performance for the duration of that period.  The Licensor will use its reasonable endeavours to bring the Force Majeure Event to a close or to find a solution by which its obligations under the License may be performed despite the Force Majeure Event.

15. WAIVER

15.1. If the Licensor fails, at any time during the term of the License, to insist upon strict performance of any of the Licensee's obligations under the License, or if the Licensor fails to exercise any of the rights or remedies to which the Licensor is entitled under the License, this shall not constitute a waiver of such rights or remedies and shall not relieve the Licensee from compliance with such obligations.

15.2. A waiver by the Licensor of any default shall not constitute a waiver of any subsequent default.

15.3. No waiver by the Licensor of any of the provisions of the License shall be effective unless it is expressly stated to be a waiver and is communicated to the Licensee in writing.

16. SEVERABILITY

If any of the terms of the License are determined by any competent authority to be invalid, unlawful or unenforceable to any extent, such term, condition or provision will to that extent be severed from the remaining terms, conditions and provisions which will continue to be valid to the fullest extent permitted by law.

17. ENTIRE AGREEMENT

17.1. This License and any document expressly referred to in it represents the entire agreement between the parties in relation to the licensing of the Software, the Documentation and supersedes any prior agreement, understanding or arrangement between the parties, whether oral or in writing.

17.2. The parties each acknowledge that, in entering into the License, they have not relied on any representation, undertaking or promise given by the other or implied from anything said or written in negotiations between the parties prior to entering into the License except as expressly stated in the License.

17.3. Neither party shall have any remedy in respect of any untrue statement made by the other, whether orally or in writing, prior to the date on which the parties entered into this License (unless such untrue statement was made fraudulently) and the other party's only remedy shall be for breach of contract as provided in these terms and conditions.

18. LAW AND JURISDICTION

The License, its subject matter or its formation (including non-contractual disputes or claims) shall be governed by and construed in accordance with Greek law and submitted to the exclusive jurisdiction of the Greek courts.
EOF

    echo

    agree=""
    read -p "Input \"I AGREE\" to accept: " agree

    if [[ "$agree" != "I AGREE" ]]; then
      exit
    fi

   echo
}

if [[ "$(operating_system)" == "darwin" ]]; then
    echo "OSX is not currently supported."
    exit 1
fi

under_maintenance() {
    echo "Down for maintenance, will be back up shortly..."
    exit
}

#under_maintenance

reserved="
    scnr
"
cwd="$(basename `pwd`)"

for i in $reserved; do
    if [[ $i == $cwd ]]; then
        echo "Installation directory name '$i' is reserved, please install under a different directory name."
        exit 1

    fi
done

print_eula

latest_version=`curl -sL https://raw.githubusercontent.com/scnr/version/main/LATEST`
scnr_url="https://github.com/scnr/installer/releases/download/v$latest_version/scnr-v$latest_version-$(operating_system)-$(architecture).tar.gz"
scnr_dir="./scnr-v$latest_version"
scnr_package="./scnr-v$latest_version.tar.gz"
scnr_db_config="$scnr_dir/.system/scnr-ui-pro/config/database.yml"
scnr_license_file="$HOME/.scnr/license.key"
log=./scnr.install.log

echo

echo "   * Downloading..."
curl -L -C - --retry 12 --retry-delay 1 --retry-all-errors $scnr_url -o $scnr_package
handle_failure

echo -n "   * Installing..."
tar xf $scnr_package
handle_failure
rm $scnr_package
echo "done."

if ! [ -f $scnr_license_file ]; then
    echo
    echo "Codename SCNR activation"
    echo "(If you don't have a license key, get one from https://ecsypno.com -- free Community and Trial editions are available too.)"
    key=""
    read -p "License key: " key
    $scnr_dir/bin/scnr_activate $key

    if [[ $? != 0 ]]; then
        echo "Activation was unsuccessful, please retry the installation process with a valid license key."
        exit 1
    fi

    echo
fi

mkdir -p $HOME/.scnr/pro/config/

db_config="$HOME/.scnr/pro/config/database.yml"

if [[ ! -f "$db_config" ]]; then
    mv $scnr_dir/.system/scnr-ui-pro/config/database.yml $HOME/.scnr/pro/config/
    mv $scnr_dir/.system/scnr-ui-pro/config/database.postgres.yml $HOME/.scnr/pro/config/
fi

rm -f $scnr_dir/.system/scnr-ui-pro/config/database.yml
ln -s $HOME/.scnr/pro/config/database.yml $scnr_dir/.system/scnr-ui-pro/config/database.yml

db="$HOME/.scnr/pro/db/production.sqlite3"

scnr_edition=`$scnr_dir/bin/scnr_edition`

if [[ $scnr_edition == "dev" || $scnr_edition == "trial" || $scnr_edition == "pro" || $scnr_edition == "enterprise" ]]; then
    if [[ -f "$db" ]]; then
        echo -n "   * Updating the DB..."
        $scnr_dir/bin/scnr_pro_task db:migrate 2>> $log 1>> $log
        handle_failure
    else
        echo -n "   * Setting up the DB..."
        $scnr_dir/bin/scnr_pro_task db:create db:migrate db:seed 2>> $log 1>> $log
        handle_failure
    fi
    echo "done."
fi

echo
echo
echo -n "Codename SCNR installed at:   "
echo $scnr_dir
echo "Installation log at: $log"
echo
echo "* For a CLI scan you can run: $scnr_dir/bin/scnr URL"

if [[ $scnr_edition == "trial" || $scnr_edition == "pro" || $scnr_edition == "enterprise" ]]; then
  echo "* To use Codename SCNR Pro you can run: $scnr_dir/bin/scnr_pro"
fi

echo
echo "Documentation can be found at: https://documentation.ecsypno.com/scnr/"
echo
