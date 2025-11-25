import 'dart:math';

/// Mock AI Service - Replace with actual OpenAI/Your AI API later
class AIService {
  /// Get AI response for a legal question
  /// TODO: Replace with actual OpenAI API call when ready
  static Future<String> getResponse(String userMessage) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 800 + Random().nextInt(1200)));

    final lowerMessage = userMessage.toLowerCase();

    // Mock responses based on keywords
    if (lowerMessage.contains('llc') || lowerMessage.contains('company')) {
      return _llcResponse();
    } else if (lowerMessage.contains('contract')) {
      return _contractResponse();
    } else if (lowerMessage.contains('trademark') ||
        lowerMessage.contains('copyright')) {
      return _ipResponse();
    } else if (lowerMessage.contains('sue') ||
        lowerMessage.contains('lawsuit')) {
      return _lawsuitResponse();
    } else if (lowerMessage.contains('divorce') ||
        lowerMessage.contains('marriage')) {
      return _familyLawResponse();
    } else if (lowerMessage.contains('tax')) {
      return _taxResponse();
    } else if (lowerMessage.contains('employee') ||
        lowerMessage.contains('employment')) {
      return _employmentResponse();
    } else if (lowerMessage.contains('rent') ||
        lowerMessage.contains('landlord') ||
        lowerMessage.contains('tenant')) {
      return _rentalResponse();
    } else if (lowerMessage.contains('will') ||
        lowerMessage.contains('estate') ||
        lowerMessage.contains('inheritance')) {
      return _estateResponse();
    } else if (lowerMessage.contains('hello') ||
        lowerMessage.contains('hi') ||
        lowerMessage.contains('hey')) {
      return _greetingResponse();
    } else {
      return _generalResponse();
    }
  }

  static String _greetingResponse() {
    return '''Hello! I'm LegalGPT, your AI legal assistant. I can help you with:

• Business formation (LLC, Corporation)
• Contract questions
• Intellectual property (Trademarks, Copyrights)
• Employment law
• Family law matters
• Real estate and rental issues
• Estate planning

What legal question can I help you with today?''';
  }

  static String _llcResponse() {
    return '''To form a Limited Liability Company (LLC), you typically need to:

1. Choose a business name that complies with state rules
2. File Articles of Organization with your state
3. Designate a registered agent
4. Create an Operating Agreement
5. Obtain an EIN from the IRS
6. Comply with state-specific requirements

Would you like more details on any of these steps?''';
  }

  static String _contractResponse() {
    return '''Key elements of a valid contract include:

1. **Offer** - One party proposes terms
2. **Acceptance** - Other party agrees to terms
3. **Consideration** - Something of value exchanged
4. **Capacity** - Parties must be legally able to contract
5. **Legality** - Purpose must be legal

Important tips:
• Always get contracts in writing
• Read all terms carefully before signing
• Consider having an attorney review important contracts

What specific contract question do you have?''';
  }

  static String _ipResponse() {
    return '''Intellectual Property protection options:

**Trademark** - Protects brand names, logos, slogans
• File with USPTO
• Lasts as long as you use it and renew

**Copyright** - Protects creative works automatically
• Registration provides additional benefits
• Lasts life of author + 70 years

**Patent** - Protects inventions
• Must file application with USPTO
• Lasts 20 years for utility patents

Would you like specific guidance on protecting your IP?''';
  }

  static String _lawsuitResponse() {
    return '''Before filing a lawsuit, consider:

1. **Statute of limitations** - Time limit to file varies by case type
2. **Jurisdiction** - Which court has authority
3. **Evidence** - Document everything
4. **Costs** - Filing fees, attorney fees, time investment
5. **Alternatives** - Mediation or arbitration may be faster/cheaper

Steps in a typical lawsuit:
• File complaint → Service → Answer → Discovery → Trial

Do you have a specific legal dispute you'd like to discuss?''';
  }

  static String _familyLawResponse() {
    return '''Family law matters are often complex and emotional. Key areas include:

**Divorce:**
• Property division
• Alimony/spousal support
• Child custody and support

**Child Custody:**
• Legal custody (decision-making)
• Physical custody (where child lives)
• Visitation schedules

**Prenuptial Agreements:**
• Must be in writing
• Full financial disclosure required
• Both parties should have attorneys

What family law matter would you like to discuss?''';
  }

  static String _taxResponse() {
    return '''Common tax law considerations:

**Business Taxes:**
• Entity type affects taxation (LLC, S-Corp, C-Corp)
• Quarterly estimated payments may be required
• Deductions can reduce taxable income

**Individual Taxes:**
• Filing status matters
• Credits vs deductions
• Capital gains rates differ from ordinary income

**Tax Issues:**
• IRS payment plans available
• Statute of limitations on audits
• Penalty abatement options

What specific tax question do you have?''';
  }

  static String _employmentResponse() {
    return '''Employment law covers the employer-employee relationship:

**Employee Rights:**
• Minimum wage and overtime
• Protection from discrimination
• Safe working conditions
• Family and medical leave

**Employer Obligations:**
• Proper classification (employee vs contractor)
• Tax withholding
• Workers' compensation insurance
• Anti-harassment policies

**Common Issues:**
• Wrongful termination
• Wage disputes
• Non-compete agreements

What employment matter concerns you?''';
  }

  static String _rentalResponse() {
    return '''Landlord-Tenant law key points:

**Tenant Rights:**
• Habitable living conditions
• Privacy (proper notice before entry)
• Security deposit return (within state deadline)
• Protection from illegal eviction

**Landlord Rights:**
• Collect rent on time
• Property maintenance access
• Eviction for cause

**Common Issues:**
• Security deposit disputes
• Repair responsibilities
• Lease termination
• Eviction process

Are you a landlord or tenant? I can provide more specific guidance.''';
  }

  static String _estateResponse() {
    return '''Estate planning essentials:

**Basic Documents:**
• **Will** - Distributes assets after death
• **Trust** - Can avoid probate, more privacy
• **Power of Attorney** - Someone to act for you if incapacitated
• **Healthcare Directive** - Medical decisions if you can't make them

**Key Considerations:**
• Name beneficiaries on accounts
• Consider guardianship for minor children
• Review and update regularly
• Store documents safely

Would you like guidance on a specific estate planning topic?''';
  }

  static String _generalResponse() {
    return '''Thank you for your question. While I can provide general legal information, I'd need more details to give you specific guidance.

Could you please tell me more about:
• The specific legal issue you're facing
• Your location (laws vary by state/country)
• Any relevant background details

Remember: This information is for educational purposes only and does not constitute legal advice. For specific legal matters, please consult a licensed attorney.

How can I help you further?''';
  }
}
