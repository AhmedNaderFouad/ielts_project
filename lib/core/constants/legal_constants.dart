class LegalConstants {
  static const String termsOfServiceText = '''
SECTION 1: INTELLECTUAL PROPERTY & PROPRIETARY RIGHTS
All source code, UI/UX designs, system architecture, database schemas, custom algorithms, workflows, screen layouts, graphic assets, and business logic of this application are the exclusive intellectual property of the developers. Unauthorized copying, replication, modification, cloning, or creating derivative works based on any part of this software—whether in structure, visual aesthetics, or functional mechanics—is strictly prohibited and constitutes a direct violation of international copyright, trademark, and intellectual property laws.

SECTION 2: PROHIBITION OF CLONING & COMPETITIVE EXPLOITATION
You are explicitly forbidden from using any portion of this application, its workflows, or its feature implementations to construct, train, or inform any competing application, software service, or commercial offering. Reverse engineering, decompiling, disassembling, extracting API endpoints, or scraping database schemas will trigger immediate automated system bans, permanent account deletion, and direct civil and legal prosecution under international Cybercrime and Intellectual Property protection acts.

SECTION 3: ACCOUNT TRANSFERABILITY & UNAUTHORIZED SHARING
Each registered account is strictly non-transferable and assigned for exclusive individual use. Sharing account credentials, allowing secondary access, or attempting to resell subscription privileges across multiple unauthorized devices is strictly forbidden. Automated security algorithms actively monitor device fingerprints; detected anomalies will lead to instantaneous credential invalidation without right of refund or appeal.
''';

  static const String privacyPolicyText = '''
SECTION 1: DATA ENCRYPTION & SECURITY PROTOCOLS
We enforce bank-grade, strict end-to-end security architectures to protect user data. Personal credentials, state tokens, and recovery keys are strictly hashed and encrypted using standard SHA-256 and AES-256 protocols before being written to Firebase Firestore servers. System administrators and third parties have zero technical ability to read, decrypt, or access raw password structures.

SECTION 2: ABSOLUTE DATA ISOLATION & NON-DISCLOSURE
We maintain a zero-tolerance policy regarding the commercialization of user data. Your personally identifiable information (PII), test score analytics, behavioral logs, and email records will NEVER be sold, leased, rented, shared, or distributed to any third-party marketing networks, data aggregators, or external commercial brokers under any circumstances.

SECTION 3: AUTOMATED THREAT AUDITING & ERASURE RIGHTS
To defend against brute-force attacks and unauthorized server exploitation, our infrastructure automatically logs anonymous security identifiers (IP address hashes, attempt counts, and session expiration timestamps). Users retain full legal authority to request complete and irreversible account erasure. Initiating account deletion permanently purges all historical progress, database documents, and authentication logs from active production servers within 30 days.
''';
}
