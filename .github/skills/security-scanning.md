# Security Scanning Guidelines

You are a security auditor specializing in DevSecOps, application security, and comprehensive cybersecurity practices.

## Purpose

Expert security auditor with comprehensive knowledge of modern cybersecurity practices, DevSecOps methodologies, and compliance frameworks. Masters vulnerability assessment, threat modeling, secure coding practices, and security automation. Specializes in building security into development pipelines and creating resilient, compliant systems.

## Capabilities

### DevSecOps & Security Automation

- **Security pipeline integration**: SAST, DAST, IAST, dependency scanning in CI/CD
- **Shift-left security**: Early vulnerability detection, secure coding practices, developer training
- **Security as Code**: Policy as Code with OPA, security infrastructure automation
- **Container security**: Image scanning, runtime security, Kubernetes security policies
- **Supply chain security**: SLSA framework, software bill of materials (SBOM), dependency management
- **Secrets management**: HashCorp Vault, cloud secret managers, secret rotation automation

### Modern Authentication & Authorization

- **Identity protocols**: OAuth 2.0/2.1, OpenID Connect, SAML 2.0, WebAuthn, FIDO2
- **JWT security**: Proper implementation, key management, token validation, security best practices
- **Zero-trust architecture**: Identity-based access, continuous verification, principle of least privilege
- **Multi-factor authentication**: TOTP, hardware tokens, biometric authentication, risk-based auth
- **Authorization patterns**: RBAC, ABAC, ReBAC, policy engines, fine-grained permissions
- **API security**: OAuth scopes, API keys, rate limiting, threat protection

### OWASP & Vulnerability Management

- **OWASP Top 10 (2021)**: Broken access control, cryptographic failures, injection, insecure design
- **OWASP ASVS**: Application Security Verification Standard, security requirements
- **OWASP SAMM**: Software Assurance Maturity Model, security maturity assessment
- **Vulnerability assessment**: Automated scanning, manual testing, penetration testing
- **Threat modeling**: STRIDE, PASTA, attack trees, threat intelligence integration
- **Risk assessment**: CVSS scoring, business impact analysis, risk prioritization

### Application Security Testing

- **Static analysis (SAST)**: SonarQube, Checkmarx, Veracode, Semgrep, CodeQL
- **Dynamic analysis (DAST)**: OWASP ZAP, Burp Suite, Nessus, web application scanning
- **Interactive testing (IAST)**: Runtime security testing, hybrid analysis approaches
- **Dependency scanning**: Snyk, WhiteSource, OWASP Dependency-Check, GitHub Security
- **Container scanning**: Twistlock, Aqua Security, Anchore, cloud-native scanning
- **Infrastructure scanning**: Nessus, OpenWAS, cloud security posture management

### Cloud Security

- **Cloud security posture**: AWS Security Hub, Azure Security Center, GCP Security Command Center
- **Infrastructure security**: Cloud security groups, network ACLs, IAM policies
- **Data protection**: Encryption at rest/in transit, key management, data classification
- **Serverless security**: Function security, event-driven security, serverless SAST/DAST
- **Container security**: Kubernetes Pod Security Standards, network policies, service mesh security
- **Multi-cloud security**: Consistent security policies, cross-cloud identity management

### Compliance & Governance

- **Regulatory frameworks**: GDPR, HIPAA, PCI-DSS, SOC 2, ISO 27001, NIST Cybersecurity Framework
- **Compliance automation**: Policy as Code, continuous compliance monitoring, audit trails
- **Data governance**: Data classification, privacy by design, data residency requirements
- **Security metrics**: KPIs, security scorecards, executive reporting, trend analysis
- **Incident response**: NIST incident response framework, forensics, breach notification

### Secure Coding & Development

- **Secure coding standards**: Language-specific security guidelines, secure libraries
- **Input validation**: Parameterized queries, input sanitization, output encoding
- **Encryption implementation**: TLS configuration, symmetric/asymmetric encryption, key management
- **Security headers**: CSP, HSTS, X-Frame-Options, SameSite cookies, CORP/COEP
- **API security**: REST/GraphQL security, rate limiting, input validation, error handling
- **Database security**: SQL injection prevention, database encryption, access controls

### Network & Infrastructure Security

- **Network segmentation**: Micro-segmentation, VLANs, security zones, network policies
- **Firewall management**: Next-generation firewalls, cloud security groups, network ACLs
- **Intrusion detection**: IDS/IPS systems, network monitoring, anomaly detection
- **VPN security**: Site-to-site VPN, client VPN, WireGuard, IPSec configuration
- **DNS security**: DNS filtering, DNSSEC, DNS over HTTPS, malicious domain detection

### Security Monitoring & Incident Response

- **SIEM/SOAR**: Splunk, Elastic Security, IBM QRadar, security orchestration and response
- **Log analysis**: Security event correlation, anomaly detection, threat hunting
- **Vulnerability management**: Vulnerability scanning, patch management, remediation tracking
- **Threat intelligence**: IOC integration, threat feeds, behavioral analysis
- **Incident response**: Playbooks, forensics, containment procedures, recovery planning

### Emerging Security Technologies

- **AI/ML security**: Model security, adversarial attacks, privacy-preserving ML
- **Quantum-safe cryptography**: Post-quantum cryptographic algorithms, migration planning
- **Zero-knowledge proofs**: Privacy-preserving authentication, blockchain security
- **Homomorphic encryption**: Privacy-preserving computation, secure data processing
- **Confidential computing**: Trusted execution environments, secure enclaves

### Security Testing & Validation

- **Penetration testing**: Web application testing, network testing, social engineering
- **Red team exercises**: Advanced persistent threat simulation, attack path analysis
- **Bug bounty programs**: Program management, vulnerability triage, reward systems
- **Security chaos engineering**: Failure injection, resilience testing, security validation
- **Compliance testing**: Regulatory requirement validation, audit preparation

## Behavioral Traits

- Implements defense-in-depth with multiple security layers and controls
- Applies principle of least privilege with granular access controls
- Never trusts user input and validates everything at multiple layers
- Fails securely without information leakage or system compromise
- Performs regular dependency scanning and vulnerability management
- Focuses on practical, actionable fixes over theoretical security risks
- Integrates security early in the development lifecycle (shift-left)
- Values automation and continuous security monitoring
- Considers business risk and impact in security decision-making
- Stays current with emerging threats and security technologies

## Knowledge Base

- OWASP guidelines, frameworks, and security testing methodologies
- Modern authentication and authorization protocols and implementations
- DevSecOps tools and practices for security automation
- Cloud security best practices across AWS, Azure, and GCP
- Compliance frameworks and regulatory requirements
- Threat modeling and risk assessment methodologies
- Security testing tools and techniques
- Incident response and forensics procedures

## Response Approach

1. **Assess security requirements** including compliance and regulatory needs
2. **Perform threat modeling** to identify potential attack vectors and risks
3. **Conduct comprehensive security testing** using appropriate tools and techniques
4. **Implement security controls** with defense-in-depth principles
5. **Automate security validation** in development and deployment pipelines
6. **Set up security monitoring** for continuous threat detection and response
7. **Document security architecture** with clear procedures and incident response plans
8. **Plan for compliance** with relevant regulatory and industry standards
9. **Provide security training** and awareness for development teams

## Example Interactions

- "Conduct comprehensive security audit of microservices architecture with DevSecOps integration"
- "Implement zero-trust authentication system with multi-factor authentication and risk-based access"
- "Design security pipeline with SAST, DAST, and container scanning for CI/CD workflow"
- "Create GDPR-compliant data processing system with privacy by design principles"
- "Perform threat modeling for cloud-native application with Kubernetes deployment"
- "Implement secure API gateway with OAuth 2.0, rate limiting, and threat protection"
- "Design incident response plan with forensics capabilities and breach notification procedures"
- "Create security automation with Policy as Code and continuous compliance monitoring"

These guidelines provide practices for security scanning.

## Attack Tree Construction

# Attack Tree Construction

Systematic attack path visualization and analysis.

## When to Use This Skill

- Visualizing complex attack scenarios
- Identifying defense gaps and priorities
- Communicating risks to stakeholders
- Planning defensive investments
- Penetration test planning
- Security architecture review

## Core Concepts

### 1. Attack Tree Structure

```
                    [Root Goal]
                         |
            ┌────────────┴────────────┐
            │                         │
       [Sub-goal 1]              [Sub-goal 2]
       (OR node)                 (AND node)
            │                         │
      ┌─────┴─────┐             ┌─────┴─────┐
      │           │             │           │
   [Attack]   [Attack]      [Attack]   [Attack]
    (leaf)     (leaf)        (leaf)     (leaf)
```

### 2. Node Types

| Type     | Symbol    | Description             |
| -------- | --------- | ----------------------- |
| **OR**   | Oval      | Any child achieves goal |
| **AND**  | Rectangle | All children required   |
| **Leaf** | Box       | Atomic attack step      |

### 3. Attack Attributes

| Attribute     | Description             | Values             |
| ------------- | ----------------------- | ------------------ |
| **Cost**      | Resources needed        | $, $$, $$$         |
| **Time**      | Duration to execute     | Hours, Days, Weeks |
| **Skill**     | Expertise required      | Low, Medium, High  |
| **Detection** | Likelihood of detection | Low, Medium, High  |

## Templates

### Template 1: Attack Tree Data Model

```python
from dataclasses import dataclass, field
from enum import Enum
from typing import List, Dict, Optional, Union
import json

class NodeType(Enum):
    OR = "or"
    AND = "and"
    LEAF = "leaf"


class Difficulty(Enum):
    TRIVIAL = 1
    LOW = 2
    MEDIUM = 3
    HIGH = 4
    EXPERT = 5


class Cost(Enum):
    FREE = 0
    LOW = 1
    MEDIUM = 2
    HIGH = 3
    VERY_HIGH = 4


class DetectionRisk(Enum):
    NONE = 0
    LOW = 1
    MEDIUM = 2
    HIGH = 3
    CERTAIN = 4


@dataclass
class AttackAttributes:
    difficulty: Difficulty = Difficulty.MEDIUM
    cost: Cost = Cost.MEDIUM
    detection_risk: DetectionRisk = DetectionRisk.MEDIUM
    time_hours: float = 8.0
    requires_insider: bool = False
    requires_physical: bool = False


@dataclass
class AttackNode:
    id: str
    name: str
    description: str
    node_type: NodeType
    attributes: AttackAttributes = field(default_factory=AttackAttributes)
    children: List['AttackNode'] = field(default_factory=list)
    mitigations: List[str] = field(default_factory=list)
    cve_refs: List[str] = field(default_factory=list)

    def add_child(self, child: 'AttackNode') -> None:
        self.children.append(child)

    def calculate_path_difficulty(self) -> float:
        """Calculate aggregate difficulty for this path."""
        if self.node_type == NodeType.LEAF:
            return self.attributes.difficulty.value

        if not self.children:
            return 0

        child_difficulties = [c.calculate_path_difficulty() for c in self.children]

        if self.node_type == NodeType.OR:
            return min(child_difficulties)
        else:  # AND
            return max(child_difficulties)

    def calculate_path_cost(self) -> float:
        """Calculate aggregate cost for this path."""
        if self.node_type == NodeType.LEAF:
            return self.attributes.cost.value

        if not self.children:
            return 0

        child_costs = [c.calculate_path_cost() for c in self.children]

        if self.node_type == NodeType.OR:
            return min(child_costs)
        else:  # AND
            return sum(child_costs)

    def to_dict(self) -> Dict:
        """Convert to dictionary for serialization."""
        return {
            "id": self.id,
            "name": self.name,
            "description": self.description,
            "type": self.node_type.value,
            "attributes": {
                "difficulty": self.attributes.difficulty.name,
                "cost": self.attributes.cost.name,
                "detection_risk": self.attributes.detection_risk.name,
                "time_hours": self.attributes.time_hours,
            },
            "mitigations": self.mitigations,
            "children": [c.to_dict() for c in self.children]
        }


@dataclass
class AttackTree:
    name: str
    description: str
    root: AttackNode
    version: str = "1.0"

    def find_easiest_path(self) -> List[AttackNode]:
        """Find the path with lowest difficulty."""
        return self._find_path(self.root, minimize="difficulty")

    def find_cheapest_path(self) -> List[AttackNode]:
        """Find the path with lowest cost."""
        return self._find_path(self.root, minimize="cost")

    def find_stealthiest_path(self) -> List[AttackNode]:
        """Find the path with lowest detection risk."""
        return self._find_path(self.root, minimize="detection")

    def _find_path(
        self,
        node: AttackNode,
        minimize: str
    ) -> List[AttackNode]:
        """Recursive path finding."""
        if node.node_type == NodeType.LEAF:
            return [node]

        if not node.children:
            return [node]

        if node.node_type == NodeType.OR:
            # Pick the best child path
            best_path = None
            best_score = float('inf')

            for child in node.children:
                child_path = self._find_path(child, minimize)
                score = self._path_score(child_path, minimize)
                if score < best_score:
                    best_score = score
                    best_path = child_path

            return [node] + (best_path or [])
        else:  # AND
            # Must traverse all children
            path = [node]
            for child in node.children:
                path.extend(self._find_path(child, minimize))
            return path

    def _path_score(self, path: List[AttackNode], metric: str) -> float:
        """Calculate score for a path."""
        if metric == "difficulty":
            return sum(n.attributes.difficulty.value for n in path if n.node_type == NodeType.LEAF)
        elif metric == "cost":
            return sum(n.attributes.cost.value for n in path if n.node_type == NodeType.LEAF)
        elif metric == "detection":
            return sum(n.attributes.detection_risk.value for n in path if n.node_type == NodeType.LEAF)
        return 0

    def get_all_leaf_attacks(self) -> List[AttackNode]:
        """Get all leaf attack nodes."""
        leaves = []
        self._collect_leaves(self.root, leaves)
        return leaves

    def _collect_leaves(self, node: AttackNode, leaves: List[AttackNode]) -> None:
        if node.node_type == NodeType.LEAF:
            leaves.append(node)
        for child in node.children:
            self._collect_leaves(child, leaves)

    def get_unmitigated_attacks(self) -> List[AttackNode]:
        """Find attacks without mitigations."""
        return [n for n in self.get_all_leaf_attacks() if not n.mitigations]

    def export_json(self) -> str:
        """Export tree to JSON."""
        return json.dumps({
            "name": self.name,
            "description": self.description,
            "version": self.version,
            "root": self.root.to_dict()
        }, indent=2)
```

### Template 2: Attack Tree Builder

```python
class AttackTreeBuilder:
    """Fluent builder for attack trees."""

    def __init__(self, name: str, description: str):
        self.name = name
        self.description = description
        self._node_stack: List[AttackNode] = []
        self._root: Optional[AttackNode] = None

    def goal(self, id: str, name: str, description: str = "") -> 'AttackTreeBuilder':
        """Set the root goal (OR node by default)."""
        self._root = AttackNode(
            id=id,
            name=name,
            description=description,
            node_type=NodeType.OR
        )
        self._node_stack = [self._root]
        return self

    def or_node(self, id: str, name: str, description: str = "") -> 'AttackTreeBuilder':
        """Add an OR sub-goal."""
        node = AttackNode(
            id=id,
            name=name,
            description=description,
            node_type=NodeType.OR
        )
        self._current().add_child(node)
        self._node_stack.append(node)
        return self

    def and_node(self, id: str, name: str, description: str = "") -> 'AttackTreeBuilder':
        """Add an AND sub-goal (all children required)."""
        node = AttackNode(
            id=id,
            name=name,
            description=description,
            node_type=NodeType.AND
        )
        self._current().add_child(node)
        self._node_stack.append(node)
        return self

    def attack(
        self,
        id: str,
        name: str,
        description: str = "",
        difficulty: Difficulty = Difficulty.MEDIUM,
        cost: Cost = Cost.MEDIUM,
        detection: DetectionRisk = DetectionRisk.MEDIUM,
        time_hours: float = 8.0,
        mitigations: List[str] = None
    ) -> 'AttackTreeBuilder':
        """Add a leaf attack node."""
        node = AttackNode(
            id=id,
            name=name,
            description=description,
            node_type=NodeType.LEAF,
            attributes=AttackAttributes(
                difficulty=difficulty,
                cost=cost,
                detection_risk=detection,
                time_hours=time_hours
            ),
            mitigations=mitigations or []
        )
        self._current().add_child(node)
        return self

    def end(self) -> 'AttackTreeBuilder':
        """Close current node, return to parent."""
        if len(self._node_stack) > 1:
            self._node_stack.pop()
        return self

    def build(self) -> AttackTree:
        """Build the attack tree."""
        if not self._root:
            raise ValueError("No root goal defined")
        return AttackTree(
            name=self.name,
            description=self.description,
            root=self._root
        )

    def _current(self) -> AttackNode:
        if not self._node_stack:
            raise ValueError("No current node")
        return self._node_stack[-1]


# Example usage
def build_account_takeover_tree() -> AttackTree:
    """Build attack tree for account takeover scenario."""
    return (
        AttackTreeBuilder("Account Takeover", "Gain unauthorized access to user account")
        .goal("G1", "Take Over User Account")

        .or_node("S1", "Steal Credentials")
            .attack(
                "A1", "Phishing Attack",
                difficulty=Difficulty.LOW,
                cost=Cost.LOW,
                detection=DetectionRisk.MEDIUM,
                mitigations=["Security awareness training", "Email filtering"]
            )
            .attack(
                "A2", "Credential Stuffing",
                difficulty=Difficulty.TRIVIAL,
                cost=Cost.LOW,
                detection=DetectionRisk.HIGH,
                mitigations=["Rate limiting", "MFA", "Password breach monitoring"]
            )
            .attack(
                "A3", "Keylogger Malware",
                difficulty=Difficulty.MEDIUM,
                cost=Cost.MEDIUM,
                detection=DetectionRisk.MEDIUM,
                mitigations=["Endpoint protection", "MFA"]
            )
        .end()

        .or_node("S2", "Bypass Authentication")
            .attack(
                "A4", "Session Hijacking",
                difficulty=Difficulty.MEDIUM,
                cost=Cost.LOW,
                detection=DetectionRisk.LOW,
                mitigations=["Secure session management", "HTTPS only"]
            )
            .attack(
                "A5", "Authentication Bypass Vulnerability",
                difficulty=Difficulty.HIGH,
                cost=Cost.LOW,
                detection=DetectionRisk.LOW,
                mitigations=["Security testing", "Code review", "WAF"]
            )
        .end()

        .or_node("S3", "Social Engineering")
            .and_node("S3.1", "Account Recovery Attack")
                .attack(
                    "A6", "Gather Personal Information",
                    difficulty=Difficulty.LOW,
                    cost=Cost.FREE,
                    detection=DetectionRisk.NONE
                )
                .attack(
                    "A7", "Call Support Desk",
                    difficulty=Difficulty.MEDIUM,
                    cost=Cost.FREE,
                    detection=DetectionRisk.MEDIUM,
                    mitigations=["Support verification procedures", "Security questions"]
                )
            .end()
        .end()

        .build()
    )
```

### Template 3: Mermaid Diagram Generator

```python
class MermaidExporter:
    """Export attack trees to Mermaid diagram format."""

    def __init__(self, tree: AttackTree):
        self.tree = tree
        self._lines: List[str] = []
        self._node_count = 0

    def export(self) -> str:
        """Export tree to Mermaid flowchart."""
        self._lines = ["flowchart TD"]
        self._export_node(self.tree.root, None)
        return "\n".join(self._lines)

    def _export_node(self, node: AttackNode, parent_id: Optional[str]) -> str:
        """Recursively export nodes."""
        node_id = f"N{self._node_count}"
        self._node_count += 1

        # Node shape based on type
        if node.node_type == NodeType.OR:
            shape = f"{node_id}(({node.name}))"
        elif node.node_type == NodeType.AND:
            shape = f"{node_id}[{node.name}]"
        else:  # LEAF
            # Color based on difficulty
            style = self._get_leaf_style(node)
            shape = f"{node_id}[/{node.name}/]"
            self._lines.append(f"    style {node_id} {style}")

        self._lines.append(f"    {shape}")

        if parent_id:
            connector = "-->" if node.node_type != NodeType.AND else "==>"
            self._lines.append(f"    {parent_id} {connector} {node_id}")

        for child in node.children:
            self._export_node(child, node_id)

        return node_id

    def _get_leaf_style(self, node: AttackNode) -> str:
        """Get style based on attack attributes."""
        colors = {
            Difficulty.TRIVIAL: "fill:#ff6b6b",  # Red - easy attack
            Difficulty.LOW: "fill:#ffa06b",
            Difficulty.MEDIUM: "fill:#ffd93d",
            Difficulty.HIGH: "fill:#6bcb77",
            Difficulty.EXPERT: "fill:#4d96ff",  # Blue - hard attack
        }
        color = colors.get(node.attributes.difficulty, "fill:#gray")
        return color


class PlantUMLExporter:
    """Export attack trees to PlantUML format."""

    def __init__(self, tree: AttackTree):
        self.tree = tree

    def export(self) -> str:
        """Export tree to PlantUML."""
        lines = [
            "@startmindmap",
            f"* {self.tree.name}",
        ]
        self._export_node(self.tree.root, lines, 1)
        lines.append("@endmindmap")
        return "\n".join(lines)

    def _export_node(self, node: AttackNode, lines: List[str], depth: int) -> None:
        """Recursively export nodes."""
        prefix = "*" * (depth + 1)

        if node.node_type == NodeType.OR:
            marker = "[OR]"
        elif node.node_type == NodeType.AND:
            marker = "[AND]"
        else:
            diff = node.attributes.difficulty.name
            marker = f"<<{diff}>>"

        lines.append(f"{prefix} {marker} {node.name}")

        for child in node.children:
            self._export_node(child, lines, depth + 1)
```

### Template 4: Attack Path Analysis

```python
from typing import Set, Tuple

class AttackPathAnalyzer:
    """Analyze attack paths and coverage."""

    def __init__(self, tree: AttackTree):
        self.tree = tree

    def get_all_paths(self) -> List[List[AttackNode]]:
        """Get all possible attack paths."""
        paths = []
        self._collect_paths(self.tree.root, [], paths)
        return paths

    def _collect_paths(
        self,
        node: AttackNode,
        current_path: List[AttackNode],
        all_paths: List[List[AttackNode]]
    ) -> None:
        """Recursively collect all paths."""
        current_path = current_path + [node]

        if node.node_type == NodeType.LEAF:
            all_paths.append(current_path)
            return

        if not node.children:
            all_paths.append(current_path)
            return

        if node.node_type == NodeType.OR:
            # Each child is a separate path
            for child in node.children:
                self._collect_paths(child, current_path, all_paths)
        else:  # AND
            # Must combine all children
            child_paths = []
            for child in node.children:
                child_sub_paths = []
                self._collect_paths(child, [], child_sub_paths)
                child_paths.append(child_sub_paths)

            # Combine paths from all AND children
            combined = self._combine_and_paths(child_paths)
            for combo in combined:
                all_paths.append(current_path + combo)

    def _combine_and_paths(
        self,
        child_paths: List[List[List[AttackNode]]]
    ) -> List[List[AttackNode]]:
        """Combine paths from AND node children."""
        if not child_paths:
            return [[]]

        if len(child_paths) == 1:
            return [path for paths in child_paths for path in paths]

        # Cartesian product of all child path combinations
        result = [[]]
        for paths in child_paths:
            new_result = []
            for existing in result:
                for path in paths:
                    new_result.append(existing + path)
            result = new_result
        return result

    def calculate_path_metrics(self, path: List[AttackNode]) -> Dict:
        """Calculate metrics for a specific path."""
        leaves = [n for n in path if n.node_type == NodeType.LEAF]

        total_difficulty = sum(n.attributes.difficulty.value for n in leaves)
        total_cost = sum(n.attributes.cost.value for n in leaves)
        total_time = sum(n.attributes.time_hours for n in leaves)
        max_detection = max((n.attributes.detection_risk.value for n in leaves), default=0)

        return {
            "steps": len(leaves),
            "total_difficulty": total_difficulty,
            "avg_difficulty": total_difficulty / len(leaves) if leaves else 0,
            "total_cost": total_cost,
            "total_time_hours": total_time,
            "max_detection_risk": max_detection,
            "requires_insider": any(n.attributes.requires_insider for n in leaves),
            "requires_physical": any(n.attributes.requires_physical for n in leaves),
        }

    def identify_critical_nodes(self) -> List[Tuple[AttackNode, int]]:
        """Find nodes that appear in the most paths."""
        paths = self.get_all_paths()
        node_counts: Dict[str, Tuple[AttackNode, int]] = {}

        for path in paths:
            for node in path:
                if node.id not in node_counts:
                    node_counts[node.id] = (node, 0)
                node_counts[node.id] = (node, node_counts[node.id][1] + 1)

        return sorted(
            node_counts.values(),
            key=lambda x: x[1],
            reverse=True
        )

    def coverage_analysis(self, mitigated_attacks: Set[str]) -> Dict:
        """Analyze how mitigations affect attack coverage."""
        all_paths = self.get_all_paths()
        blocked_paths = []
        open_paths = []

        for path in all_paths:
            path_attacks = {n.id for n in path if n.node_type == NodeType.LEAF}
            if path_attacks & mitigated_attacks:
                blocked_paths.append(path)
            else:
                open_paths.append(path)

        return {
            "total_paths": len(all_paths),
            "blocked_paths": len(blocked_paths),
            "open_paths": len(open_paths),
            "coverage_percentage": len(blocked_paths) / len(all_paths) * 100 if all_paths else 0,
            "open_path_details": [
                {"path": [n.name for n in p], "metrics": self.calculate_path_metrics(p)}
                for p in open_paths[:5]  # Top 5 open paths
            ]
        }

    def prioritize_mitigations(self) -> List[Dict]:
        """Prioritize mitigations by impact."""
        critical_nodes = self.identify_critical_nodes()
        paths = self.get_all_paths()
        total_paths = len(paths)

        recommendations = []
        for node, count in critical_nodes:
            if node.node_type == NodeType.LEAF and node.mitigations:
                recommendations.append({
                    "attack": node.name,
                    "attack_id": node.id,
                    "paths_blocked": count,
                    "coverage_impact": count / total_paths * 100,
                    "difficulty": node.attributes.difficulty.name,
                    "mitigations": node.mitigations,
                })

        return sorted(recommendations, key=lambda x: x["coverage_impact"], reverse=True)
```

## Best Practices

### Do's

- **Start with clear goals** - Define what attacker wants
- **Be exhaustive** - Consider all attack vectors
- **Attribute attacks** - Cost, skill, and detection
- **Update regularly** - New threats emerge
- **Validate with experts** - Red team review

### Don'ts

- **Don't oversimplify** - Real attacks are complex
- **Don't ignore dependencies** - AND nodes matter
- **Don't forget insider threats** - Not all attackers are external
- **Don't skip mitigations** - Trees are for defense planning
- **Don't make it static** - Threat landscape evolves

## Resources

- [Attack Trees by Bruce Schneier](https://www.schneier.com/academic/archives/1999/12/attack_trees.html)
- [MITRE ATT&CK Framework](https://attack.mitre.org/)
- [OWASP Attack Surface Analysis](https://owasp.org/www-community/controls/Attack_Surface_Analysis_Cheat_Sheet)

## Sast Configuration

# SAST Configuration

Static Application Security Testing (SAST) tool setup, configuration, and custom rule creation for comprehensive security scanning across multiple programming languages.

## Overview

This skill provides comprehensive guidance for setting up and configuring SAST tools including Semgrep, SonarQube, and CodeQL. Use this skill when you need to:

- Set up SAST scanning in CI/CD pipelines
- Create custom security rules for your codebase
- Configure quality gates and compliance policies
- Optimize scan performance and reduce false positives
- Integrate multiple SAST tools for defense-in-depth

## Core Capabilities

### 1. Semgrep Configuration

- Custom rule creation with pattern matching
- Language-specific security rules (Python, JavaScript, Go, Java, etc.)
- CI/CD integration (GitHub Actions, GitLab CI, Jenkins)
- False positive tuning and rule optimization
- Organizational policy enforcement

### 2. SonarQube Setup

- Quality gate configuration
- Security hotspot analysis
- Code coverage and technical debt tracking
- Custom quality profiles for languages
- Enterprise integration with LDAP/SAML

### 3. CodeQL Analysis

- GitHub Advanced Security integration
- Custom query development
- Vulnerability variant analysis
- Security research workflows
- SARIF result processing

## Quick Start

### Initial Assessment

1. Identify primary programming languages in your codebase
2. Determine compliance requirements (PCI-DSS, SOC 2, etc.)
3. Choose SAST tool based on language support and integration needs
4. Review baseline scan to understand current security posture

### Basic Setup

```bash
# Semgrep quick start
pip install semgrep
semgrep --config=auto --error

# SonarQube with Docker
docker run -d --name sonarqube -p 9000:9000 sonarqube:latest

# CodeQL CLI setup
gh extension install github/gh-codeql
codeql database create mydb --language=python
```

## Reference Documentation

- [Semgrep Rule Creation](references/semgrep-rules.md) - Pattern-based security rule development
- [SonarQube Configuration](references/sonarqube-config.md) - Quality gates and profiles
- [CodeQL Setup Guide](references/codeql-setup.md) - Query development and workflows

## Templates & Assets

- [semgrep-config.yml](assets/semgrep-config.yml) - Production-ready Semgrep configuration
- [sonarqube-settings.xml](assets/sonarqube-settings.xml) - SonarQube quality profile template
- [run-sast.sh](scripts/run-sast.sh) - Automated SAST execution script

## Integration Patterns

### CI/CD Pipeline Integration

```yaml
# GitHub Actions example
- name: Run Semgrep
  uses: returntocorp/semgrep-action@v1
  with:
    config: >-
      p/security-audit
      p/owasp-top-ten
```

### Pre-commit Hook

```bash
# .pre-commit-config.yaml
- repo: https://github.com/returntocorp/semgrep
  rev: v1.45.0
  hooks:
    - id: semgrep
      args: ['--config=auto', '--error']
```

## Best Practices

1. **Start with Baseline**
   - Run initial scan to establish security baseline
   - Prioritize critical and high severity findings
   - Create remediation roadmap

2. **Incremental Adoption**
   - Begin with security-focused rules
   - Gradually add code quality rules
   - Implement blocking only for critical issues

3. **False Positive Management**
   - Document legitimate suppressions
   - Create allow lists for known safe patterns
   - Regularly review suppressed findings

4. **Performance Optimization**
   - Exclude test files and generated code
   - Use incremental scanning for large codebases
   - Cache scan results in CI/CD

5. **Team Enablement**
   - Provide security training for developers
   - Create internal documentation for common patterns
   - Establish security champions program

## Common Use Cases

### New Project Setup

```bash
./scripts/run-sast.sh --setup --language python --tools semgrep,sonarqube
```

### Custom Rule Development

```yaml
# See references/semgrep-rules.md for detailed examples
rules:
  - id: hardcoded-jwt-secret
    pattern: jwt.encode($DATA, "...", ...)
    message: JWT secret should not be hardcoded
    severity: ERROR
```

### Compliance Scanning

```bash
# PCI-DSS focused scan
semgrep --config p/pci-dss --json -o pci-scan-results.json
```

## Troubleshooting

### High False Positive Rate

- Review and tune rule sensitivity
- Add path filters to exclude test files
- Use nostmt metadata for noisy patterns
- Create organization-specific rule exceptions

### Performance Issues

- Enable incremental scanning
- Parallelize scans across modules
- Optimize rule patterns for efficiency
- Cache dependencies and scan results

### Integration Failures

- Verify API tokens and credentials
- Check network connectivity and proxy settings
- Review SARIF output format compatibility
- Validate CI/CD runner permissions

## Related Skills

- [OWASP Top 10 Checklist](../owasp-top10-checklist/SKILL.md)
- [Container Security](../container-security/SKILL.md)
- [Dependency Scanning](../dependency-scanning/SKILL.md)

## Tool Comparison

| Tool      | Best For                 | Language Support | Cost            | Integration   |
| --------- | ------------------------ | ---------------- | --------------- | ------------- |
| Semgrep   | Custom rules, fast scans | 30+ languages    | Free/Enterprise | Excellent     |
| SonarQube | Code quality + security  | 25+ languages    | Free/Commercial | Good          |
| CodeQL    | Deep analysis, research  | 10+ languages    | Free (OSS)      | GitHub native |

## Next Steps

1. Complete initial SAST tool setup
2. Run baseline security scan
3. Create custom rules for organization-specific patterns
4. Integrate into CI/CD pipeline
5. Establish security gate policies
6. Train development team on findings and remediation

## Security Requirement Extraction

# Security Requirement Extraction

Transform threat analysis into actionable security requirements.

## When to Use This Skill

- Converting threat models to requirements
- Writing security user stories
- Creating security test cases
- Building security acceptance criteria
- Compliance requirement mapping
- Security architecture documentation

## Core Concepts

### 1. Requirement Categories

```
Business Requirements → Security Requirements → Technical Controls
         ↓                       ↓                      ↓
  "Protect customer    "Encrypt PII at rest"   "AES-256 encryption
   data"                                        with KMS key rotation"
```

### 2. Security Requirement Types

| Type               | Focus                   | Example                               |
| ------------------ | ----------------------- | ------------------------------------- |
| **Functional**     | What system must do     | "System must authenticate users"      |
| **Non-functional** | How system must perform | "Authentication must complete in <2s" |
| **Constraint**     | Limitations imposed     | "Must use approved crypto libraries"  |

### 3. Requirement Attributes

| Attribute        | Description                 |
| ---------------- | --------------------------- |
| **Traceability** | Links to threats/compliance |
| **Testability**  | Can be verified             |
| **Priority**     | Business importance         |
| **Risk Level**   | Impact if not met           |

## Templates

### Template 1: Security Requirement Model

```python
from dataclasses import dataclass, field
from enum import Enum
from typing import List, Dict, Optional, Set
from datetime import datetime

class RequirementType(Enum):
    FUNCTIONAL = "functional"
    NON_FUNCTIONAL = "non_functional"
    CONSTRAINT = "constraint"


class Priority(Enum):
    CRITICAL = 1
    HIGH = 2
    MEDIUM = 3
    LOW = 4


class SecurityDomain(Enum):
    AUTHENTICATION = "authentication"
    AUTHORIZATION = "authorization"
    DATA_PROTECTION = "data_protection"
    AUDIT_LOGGING = "audit_logging"
    INPUT_VALIDATION = "input_validation"
    ERROR_HANDLING = "error_handling"
    SESSION_MANAGEMENT = "session_management"
    CRYPTOGRAPHY = "cryptography"
    NETWORK_SECURITY = "network_security"
    AVAILABILITY = "availability"


class ComplianceFramework(Enum):
    PCI_DSS = "pci_dss"
    HIPAA = "hipaa"
    GDPR = "gdpr"
    SOC2 = "soc2"
    NIST_CSF = "nist_csf"
    ISO_27001 = "iso_27001"
    OWASP = "owasp"


@dataclass
class SecurityRequirement:
    id: str
    title: str
    description: str
    req_type: RequirementType
    domain: SecurityDomain
    priority: Priority
    rationale: str = ""
    acceptance_criteria: List[str] = field(default_factory=list)
    test_cases: List[str] = field(default_factory=list)
    threat_refs: List[str] = field(default_factory=list)
    compliance_refs: List[str] = field(default_factory=list)
    dependencies: List[str] = field(default_factory=list)
    status: str = "draft"
    owner: str = ""
    created_date: datetime = field(default_factory=datetime.now)

    def to_user_story(self) -> str:
        """Convert to user story format."""
        return f"""
**{self.id}: {self.title}**

As a security-conscious system,
I need to {self.description.lower()},
So that {self.rationale.lower()}.

**Acceptance Criteria:**
{chr(10).join(f'- [ ] {ac}' for ac in self.acceptance_criteria)}

**Priority:** {self.priority.name}
**Domain:** {self.domain.value}
**Threat References:** {', '.join(self.threat_refs)}
"""

    def to_test_spec(self) -> str:
        """Convert to test specification."""
        return f"""
## Test Specification: {self.id}

### Requirement
{self.description}

### Test Cases
{chr(10).join(f'{i+1}. {tc}' for i, tc in enumerate(self.test_cases))}

### Acceptance Criteria Verification
{chr(10).join(f'- {ac}' for ac in self.acceptance_criteria)}
"""


@dataclass
class RequirementSet:
    name: str
    version: str
    requirements: List[SecurityRequirement] = field(default_factory=list)

    def add(self, req: SecurityRequirement) -> None:
        self.requirements.append(req)

    def get_by_domain(self, domain: SecurityDomain) -> List[SecurityRequirement]:
        return [r for r in self.requirements if r.domain == domain]

    def get_by_priority(self, priority: Priority) -> List[SecurityRequirement]:
        return [r for r in self.requirements if r.priority == priority]

    def get_by_threat(self, threat_id: str) -> List[SecurityRequirement]:
        return [r for r in self.requirements if threat_id in r.threat_refs]

    def get_critical_requirements(self) -> List[SecurityRequirement]:
        return [r for r in self.requirements if r.priority == Priority.CRITICAL]

    def export_markdown(self) -> str:
        """Export all requirements as markdown."""
        lines = [f"# Security Requirements: {self.name}\n"]
        lines.append(f"Version: {self.version}\n")

        for domain in SecurityDomain:
            domain_reqs = self.get_by_domain(domain)
            if domain_reqs:
                lines.append(f"\n## {domain.value.replace('_', ' ').title()}\n")
                for req in domain_reqs:
                    lines.append(req.to_user_story())

        return "\n".join(lines)

    def traceability_matrix(self) -> Dict[str, List[str]]:
        """Generate threat-to-requirement traceability."""
        matrix = {}
        for req in self.requirements:
            for threat_id in req.threat_refs:
                if threat_id not in matrix:
                    matrix[threat_id] = []
                matrix[threat_id].append(req.id)
        return matrix
```

### Template 2: Threat-to-Requirement Extractor

```python
from dataclasses import dataclass
from typing import List, Dict, Tuple

@dataclass
class ThreatInput:
    id: str
    category: str  # STRIDE category
    title: str
    description: str
    target: str
    impact: str
    likelihood: str


class RequirementExtractor:
    """Extract security requirements from threats."""

    # Mapping of STRIDE categories to security domains and requirement patterns
    STRIDE_MAPPINGS = {
        "SPOOFING": {
            "domains": [SecurityDomain.AUTHENTICATION, SecurityDomain.SESSION_MANAGEMENT],
            "patterns": [
                ("Implement strong authentication for {target}",
                 "Ensure {target} authenticates all users before granting access"),
                ("Validate identity tokens for {target}",
                 "All authentication tokens must be cryptographically verified"),
                ("Implement session management for {target}",
                 "Sessions must be securely managed with proper expiration"),
            ]
        },
        "TAMPERING": {
            "domains": [SecurityDomain.INPUT_VALIDATION, SecurityDomain.DATA_PROTECTION],
            "patterns": [
                ("Validate all input to {target}",
                 "All input must be validated against expected formats"),
                ("Implement integrity checks for {target}",
                 "Data integrity must be verified using cryptographic signatures"),
                ("Protect {target} from modification",
                 "Implement controls to prevent unauthorized data modification"),
            ]
        },
        "REPUDIATION": {
            "domains": [SecurityDomain.AUDIT_LOGGING],
            "patterns": [
                ("Log all security events for {target}",
                 "Security-relevant events must be logged for audit purposes"),
                ("Implement non-repudiation for {target}",
                 "Critical actions must have cryptographic proof of origin"),
                ("Protect audit logs for {target}",
                 "Audit logs must be tamper-evident and protected"),
            ]
        },
        "INFORMATION_DISCLOSURE": {
            "domains": [SecurityDomain.DATA_PROTECTION, SecurityDomain.CRYPTOGRAPHY],
            "patterns": [
                ("Encrypt sensitive data in {target}",
                 "Sensitive data must be encrypted at rest and in transit"),
                ("Implement access controls for {target}",
                 "Data access must be restricted based on need-to-know"),
                ("Prevent information leakage from {target}",
                 "Error messages and logs must not expose sensitive information"),
            ]
        },
        "DENIAL_OF_SERVICE": {
            "domains": [SecurityDomain.AVAILABILITY, SecurityDomain.INPUT_VALIDATION],
            "patterns": [
                ("Implement rate limiting for {target}",
                 "Requests must be rate-limited to prevent resource exhaustion"),
                ("Ensure availability of {target}",
                 "System must remain available under high load conditions"),
                ("Implement resource quotas for {target}",
                 "Resource consumption must be bounded and monitored"),
            ]
        },
        "ELEVATION_OF_PRIVILEGE": {
            "domains": [SecurityDomain.AUTHORIZATION],
            "patterns": [
                ("Enforce authorization for {target}",
                 "All actions must be authorized based on user permissions"),
                ("Implement least privilege for {target}",
                 "Users must only have minimum necessary permissions"),
                ("Validate permissions for {target}",
                 "Permission checks must be performed server-side"),
            ]
        },
    }

    def extract_requirements(
        self,
        threats: List[ThreatInput],
        project_name: str
    ) -> RequirementSet:
        """Extract security requirements from threats."""
        req_set = RequirementSet(
            name=f"{project_name} Security Requirements",
            version="1.0"
        )

        req_counter = 1
        for threat in threats:
            reqs = self._threat_to_requirements(threat, req_counter)
            for req in reqs:
                req_set.add(req)
            req_counter += len(reqs)

        return req_set

    def _threat_to_requirements(
        self,
        threat: ThreatInput,
        start_id: int
    ) -> List[SecurityRequirement]:
        """Convert a single threat to requirements."""
        requirements = []
        mapping = self.STRIDE_MAPPINGS.get(threat.category, {})
        domains = mapping.get("domains", [])
        patterns = mapping.get("patterns", [])

        priority = self._calculate_priority(threat.impact, threat.likelihood)

        for i, (title_pattern, desc_pattern) in enumerate(patterns):
            req = SecurityRequirement(
                id=f"SR-{start_id + i:03d}",
                title=title_pattern.format(target=threat.target),
                description=desc_pattern.format(target=threat.target),
                req_type=RequirementType.FUNCTIONAL,
                domain=domains[i % len(domains)] if domains else SecurityDomain.DATA_PROTECTION,
                priority=priority,
                rationale=f"Mitigates threat: {threat.title}",
                threat_refs=[threat.id],
                acceptance_criteria=self._generate_acceptance_criteria(
                    threat.category, threat.target
                ),
                test_cases=self._generate_test_cases(
                    threat.category, threat.target
                )
            )
            requirements.append(req)

        return requirements

    def _calculate_priority(self, impact: str, likelihood: str) -> Priority:
        """Calculate requirement priority from threat attributes."""
        score_map = {"LOW": 1, "MEDIUM": 2, "HIGH": 3, "CRITICAL": 4}
        impact_score = score_map.get(impact.upper(), 2)
        likelihood_score = score_map.get(likelihood.upper(), 2)

        combined = impact_score * likelihood_score

        if combined >= 12:
            return Priority.CRITICAL
        elif combined >= 6:
            return Priority.HIGH
        elif combined >= 3:
            return Priority.MEDIUM
        return Priority.LOW

    def _generate_acceptance_criteria(
        self,
        category: str,
        target: str
    ) -> List[str]:
        """Generate acceptance criteria for requirement."""
        criteria_templates = {
            "SPOOFING": [
                f"Users must authenticate before accessing {target}",
                "Authentication failures are logged and monitored",
                "Multi-factor authentication is available for sensitive operations",
            ],
            "TAMPERING": [
                f"All input to {target} is validated",
                "Data integrity is verified before processing",
                "Modification attempts trigger alerts",
            ],
            "REPUDIATION": [
                f"All actions on {target} are logged with user identity",
                "Logs cannot be modified by regular users",
                "Log retention meets compliance requirements",
            ],
            "INFORMATION_DISCLOSURE": [
                f"Sensitive data in {target} is encrypted",
                "Access to sensitive data is logged",
                "Error messages do not reveal sensitive information",
            ],
            "DENIAL_OF_SERVICE": [
                f"Rate limiting is enforced on {target}",
                "System degrades gracefully under load",
                "Resource exhaustion triggers alerts",
            ],
            "ELEVATION_OF_PRIVILEGE": [
                f"Authorization is checked for all {target} operations",
                "Users cannot access resources beyond their permissions",
                "Privilege changes are logged and monitored",
            ],
        }
        return criteria_templates.get(category, [])

    def _generate_test_cases(
        self,
        category: str,
        target: str
    ) -> List[str]:
        """Generate test cases for requirement."""
        test_templates = {
            "SPOOFING": [
                f"Test: Unauthenticated access to {target} is denied",
                "Test: Invalid credentials are rejected",
                "Test: Session tokens cannot be forged",
            ],
            "TAMPERING": [
                f"Test: Invalid input to {target} is rejected",
                "Test: Tampered data is detected and rejected",
                "Test: SQL injection attempts are blocked",
            ],
            "REPUDIATION": [
                "Test: Security events are logged",
                "Test: Logs include sufficient detail for forensics",
                "Test: Log integrity is protected",
            ],
            "INFORMATION_DISCLOSURE": [
                f"Test: {target} data is encrypted in transit",
                f"Test: {target} data is encrypted at rest",
                "Test: Error messages are sanitized",
            ],
            "DENIAL_OF_SERVICE": [
                f"Test: Rate limiting on {target} works correctly",
                "Test: System handles burst traffic gracefully",
                "Test: Resource limits are enforced",
            ],
            "ELEVATION_OF_PRIVILEGE": [
                f"Test: Unauthorized access to {target} is denied",
                "Test: Privilege escalation attempts are blocked",
                "Test: IDOR vulnerabilities are not present",
            ],
        }
        return test_templates.get(category, [])
```

### Template 3: Compliance Mapping

```python
from typing import Dict, List, Set

class ComplianceMapper:
    """Map security requirements to compliance frameworks."""

    FRAMEWORK_CONTROLS = {
        ComplianceFramework.PCI_DSS: {
            SecurityDomain.AUTHENTICATION: ["8.1", "8.2", "8.3"],
            SecurityDomain.AUTHORIZATION: ["7.1", "7.2"],
            SecurityDomain.DATA_PROTECTION: ["3.4", "3.5", "4.1"],
            SecurityDomain.AUDIT_LOGGING: ["10.1", "10.2", "10.3"],
            SecurityDomain.NETWORK_SECURITY: ["1.1", "1.2", "1.3"],
            SecurityDomain.CRYPTOGRAPHY: ["3.5", "3.6", "4.1"],
        },
        ComplianceFramework.HIPAA: {
            SecurityDomain.AUTHENTICATION: ["164.312(d)"],
            SecurityDomain.AUTHORIZATION: ["164.312(a)(1)"],
            SecurityDomain.DATA_PROTECTION: ["164.312(a)(2)(iv)", "164.312(e)(2)(ii)"],
            SecurityDomain.AUDIT_LOGGING: ["164.312(b)"],
        },
        ComplianceFramework.GDPR: {
            SecurityDomain.DATA_PROTECTION: ["Art. 32", "Art. 25"],
            SecurityDomain.AUDIT_LOGGING: ["Art. 30"],
            SecurityDomain.AUTHORIZATION: ["Art. 25"],
        },
        ComplianceFramework.OWASP: {
            SecurityDomain.AUTHENTICATION: ["V2.1", "V2.2", "V2.3"],
            SecurityDomain.SESSION_MANAGEMENT: ["V3.1", "V3.2", "V3.3"],
            SecurityDomain.INPUT_VALIDATION: ["V5.1", "V5.2", "V5.3"],
            SecurityDomain.CRYPTOGRAPHY: ["V6.1", "V6.2"],
            SecurityDomain.ERROR_HANDLING: ["V7.1", "V7.2"],
            SecurityDomain.DATA_PROTECTION: ["V8.1", "V8.2", "V8.3"],
            SecurityDomain.AUDIT_LOGGING: ["V7.1", "V7.2"],
        },
    }

    def map_requirement_to_compliance(
        self,
        requirement: SecurityRequirement,
        frameworks: List[ComplianceFramework]
    ) -> Dict[str, List[str]]:
        """Map a requirement to compliance controls."""
        mapping = {}
        for framework in frameworks:
            controls = self.FRAMEWORK_CONTROLS.get(framework, {})
            domain_controls = controls.get(requirement.domain, [])
            if domain_controls:
                mapping[framework.value] = domain_controls
        return mapping

    def get_requirements_for_control(
        self,
        requirement_set: RequirementSet,
        framework: ComplianceFramework,
        control_id: str
    ) -> List[SecurityRequirement]:
        """Find requirements that satisfy a compliance control."""
        matching = []
        framework_controls = self.FRAMEWORK_CONTROLS.get(framework, {})

        for domain, controls in framework_controls.items():
            if control_id in controls:
                matching.extend(requirement_set.get_by_domain(domain))

        return matching

    def generate_compliance_matrix(
        self,
        requirement_set: RequirementSet,
        frameworks: List[ComplianceFramework]
    ) -> Dict[str, Dict[str, List[str]]]:
        """Generate compliance traceability matrix."""
        matrix = {}

        for framework in frameworks:
            matrix[framework.value] = {}
            framework_controls = self.FRAMEWORK_CONTROLS.get(framework, {})

            for domain, controls in framework_controls.items():
                for control in controls:
                    reqs = self.get_requirements_for_control(
                        requirement_set, framework, control
                    )
                    if reqs:
                        matrix[framework.value][control] = [r.id for r in reqs]

        return matrix

    def gap_analysis(
        self,
        requirement_set: RequirementSet,
        framework: ComplianceFramework
    ) -> Dict[str, List[str]]:
        """Identify compliance gaps."""
        gaps = {"missing_controls": [], "weak_coverage": []}
        framework_controls = self.FRAMEWORK_CONTROLS.get(framework, {})

        for domain, controls in framework_controls.items():
            domain_reqs = requirement_set.get_by_domain(domain)
            for control in controls:
                matching = self.get_requirements_for_control(
                    requirement_set, framework, control
                )
                if not matching:
                    gaps["missing_controls"].append(f"{framework.value}:{control}")
                elif len(matching) < 2:
                    gaps["weak_coverage"].append(f"{framework.value}:{control}")

        return gaps
```

### Template 4: Security User Story Generator

```python
class SecurityUserStoryGenerator:
    """Generate security-focused user stories."""

    STORY_TEMPLATES = {
        SecurityDomain.AUTHENTICATION: {
            "as_a": "security-conscious user",
            "so_that": "my identity is protected from impersonation",
        },
        SecurityDomain.AUTHORIZATION: {
            "as_a": "system administrator",
            "so_that": "users can only access resources appropriate to their role",
        },
        SecurityDomain.DATA_PROTECTION: {
            "as_a": "data owner",
            "so_that": "my sensitive information remains confidential",
        },
        SecurityDomain.AUDIT_LOGGING: {
            "as_a": "security analyst",
            "so_that": "I can investigate security incidents",
        },
        SecurityDomain.INPUT_VALIDATION: {
            "as_a": "application developer",
            "so_that": "the system is protected from malicious input",
        },
    }

    def generate_story(self, requirement: SecurityRequirement) -> str:
        """Generate a user story from requirement."""
        template = self.STORY_TEMPLATES.get(
            requirement.domain,
            {"as_a": "user", "so_that": "the system is secure"}
        )

        story = f"""
## {requirement.id}: {requirement.title}

**User Story:**
As a {template['as_a']},
I want the system to {requirement.description.lower()},
So that {template['so_that']}.

**Priority:** {requirement.priority.name}
**Type:** {requirement.req_type.value}
**Domain:** {requirement.domain.value}

**Acceptance Criteria:**
{self._format_acceptance_criteria(requirement.acceptance_criteria)}

**Definition of Done:**
- [ ] Implementation complete
- [ ] Security tests pass
- [ ] Code review complete
- [ ] Security review approved
- [ ] Documentation updated

**Security Test Cases:**
{self._format_test_cases(requirement.test_cases)}

**Traceability:**
- Threats: {', '.join(requirement.threat_refs) or 'N/A'}
- Compliance: {', '.join(requirement.compliance_refs) or 'N/A'}
"""
        return story

    def _format_acceptance_criteria(self, criteria: List[str]) -> str:
        return "\n".join(f"- [ ] {c}" for c in criteria) if criteria else "- [ ] TBD"

    def _format_test_cases(self, tests: List[str]) -> str:
        return "\n".join(f"- {t}" for t in tests) if tests else "- TBD"

    def generate_epic(
        self,
        requirement_set: RequirementSet,
        domain: SecurityDomain
    ) -> str:
        """Generate an epic for a security domain."""
        reqs = requirement_set.get_by_domain(domain)

        epic = f"""
# Security Epic: {domain.value.replace('_', ' ').title()}

## Overview
This epic covers all security requirements related to {domain.value.replace('_', ' ')}.

## Business Value
- Protect against {domain.value.replace('_', ' ')} related threats
- Meet compliance requirements
- Reduce security risk

## Stories in this Epic
{chr(10).join(f'- [{r.id}] {r.title}' for r in reqs)}

## Acceptance Criteria
- All stories complete
- Security tests passing
- Security review approved
- Compliance requirements met

## Risk if Not Implemented
- Vulnerability to {domain.value.replace('_', ' ')} attacks
- Compliance violations
- Potential data breach

## Dependencies
{chr(10).join(f'- {d}' for r in reqs for d in r.dependencies) or '- None identified'}
"""
        return epic
```

## Best Practices

### Do's

- **Trace to threats** - Every requirement should map to threats
- **Be specific** - Vague requirements can't be tested
- **Include acceptance criteria** - Define "done"
- **Consider compliance** - Map to frameworks early
- **Review regularly** - Requirements evolve with threats

### Don'ts

- **Don't be generic** - "Be secure" is not a requirement
- **Don't skip rationale** - Explain why it matters
- **Don't ignore priorities** - Not all requirements are equal
- **Don't forget testability** - If you can't test it, you can't verify it
- **Don't work in isolation** - Involve stakeholders

## Resources

- [OWASP ASVS](https://owasp.org/www-project-application-security-verification-standard/)
- [NIST SP 800-53](https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final)
- [Security User Stories](https://www.oreilly.com/library/view/agile-application-security/9781491938836/)

## Stride Analysis Patterns

# STRIDE Analysis Patterns

Systematic threat identification using the STRIDE methodology.

## When to Use This Skill

- Starting new threat modeling sessions
- Analyzing existing system architecture
- Reviewing security design decisions
- Creating threat documentation
- Training teams on threat identification
- Compliance and audit preparation

## Core Concepts

### 1. STRIDE Categories

```
S - Spoofing       → Authentication threats
T - Tampering      → Integrity threats
R - Repudiation    → Non-repudiation threats
I - Information    → Confidentiality threats
    Disclosure
D - Denial of      → Availability threats
    Service
E - Elevation of   → Authorization threats
    Privilege
```

### 2. Threat Analysis Matrix

| Category            | Question                                  | Control Family |
| ------------------- | ----------------------------------------- | -------------- |
| **Spoofing**        | Can attacker pretend to be someone else?  | Authentication |
| **Tampering**       | Can attacker modify data in transit/rest? | Integrity      |
| **Repudiation**     | Can attacker deny actions?                | Logging/Audit  |
| **Info Disclosure** | Can attacker access unauthorized data?    | Encryption     |
| **DoS**             | Can attacker disrupt availability?        | Rate limiting  |
| **Elevation**       | Can attacker gain higher privileges?      | Authorization  |

## Templates

### Template 1: STRIDE Threat Model Document

```markdown
# Threat Model: [System Name]

## 1. System Overview

### 1.1 Description

[Brief description of the system and its purpose]

### 1.2 Data Flow Diagram
```

[User] --> [Web App] --> [API Gateway] --> [Backend Services]
|
v
[Database]

```

### 1.3 Trust Boundaries
- **External Boundary**: Internet to DMZ
- **Internal Boundary**: DMZ to Internal Network
- **Data Boundary**: Application to Database

## 2. Assets

| Asset | Sensitivity | Description |
|-------|-------------|-------------|
| User Credentials | High | Authentication tokens, passwords |
| Personal Data | High | PII, financial information |
| Session Data | Medium | Active user sessions |
| Application Logs | Medium | System activity records |
| Configuration | High | System settings, secrets |

## 3. STRIDE Analysis

### 3.1 Spoofing Threats

| ID | Threat | Target | Impact | Likelihood |
|----|--------|--------|--------|------------|
| S1 | Session hijacking | User sessions | High | Medium |
| S2 | Token forgery | JWT tokens | High | Low |
| S3 | Credential stuffing | Login endpoint | High | High |

**Mitigations:**
- [ ] Implement MFA
- [ ] Use secure session management
- [ ] Implement account lockout policies

### 3.2 Tampering Threats

| ID | Threat | Target | Impact | Likelihood |
|----|--------|--------|--------|------------|
| T1 | SQL injection | Database queries | Critical | Medium |
| T2 | Parameter manipulation | API requests | High | High |
| T3 | File upload abuse | File storage | High | Medium |

**Mitigations:**
- [ ] Input validation on all endpoints
- [ ] Parameterized queries
- [ ] File type validation

### 3.3 Repudiation Threats

| ID | Threat | Target | Impact | Likelihood |
|----|--------|--------|--------|------------|
| R1 | Transaction denial | Financial ops | High | Medium |
| R2 | Access log tampering | Audit logs | Medium | Low |
| R3 | Action attribution | User actions | Medium | Medium |

**Mitigations:**
- [ ] Comprehensive audit logging
- [ ] Log integrity protection
- [ ] Digital signatures for critical actions

### 3.4 Information Disclosure Threats

| ID | Threat | Target | Impact | Likelihood |
|----|--------|--------|--------|------------|
| I1 | Data breach | User PII | Critical | Medium |
| I2 | Error message leakage | System info | Low | High |
| I3 | Insecure transmission | Network traffic | High | Medium |

**Mitigations:**
- [ ] Encryption at rest and in transit
- [ ] Sanitize error messages
- [ ] Implement TLS 1.3

### 3.5 Denial of Service Threats

| ID | Threat | Target | Impact | Likelihood |
|----|--------|--------|--------|------------|
| D1 | Resource exhaustion | API servers | High | High |
| D2 | Database overload | Database | Critical | Medium |
| D3 | Bandwidth saturation | Network | High | Medium |

**Mitigations:**
- [ ] Rate limiting
- [ ] Auto-scaling
- [ ] DDoS protection

### 3.6 Elevation of Privilege Threats

| ID | Threat | Target | Impact | Likelihood |
|----|--------|--------|--------|------------|
| E1 | IDOR vulnerabilities | User resources | High | High |
| E2 | Role manipulation | Admin access | Critical | Low |
| E3 | JWT claim tampering | Authorization | High | Medium |

**Mitigations:**
- [ ] Proper authorization checks
- [ ] Principle of least privilege
- [ ] Server-side role validation

## 4. Risk Assessment

### 4.1 Risk Matrix

```

              IMPACT
         Low  Med  High Crit
    Low   1    2    3    4

L Med 2 4 6 8
I High 3 6 9 12
K Crit 4 8 12 16

```

### 4.2 Prioritized Risks

| Rank | Threat | Risk Score | Priority |
|------|--------|------------|----------|
| 1 | SQL Injection (T1) | 12 | Critical |
| 2 | IDOR (E1) | 9 | High |
| 3 | Credential Stuffing (S3) | 9 | High |
| 4 | Data Breach (I1) | 8 | High |

## 5. Recommendations

### Immediate Actions
1. Implement input validation framework
2. Add rate limiting to authentication endpoints
3. Enable comprehensive audit logging

### Short-term (30 days)
1. Deploy WAF with OWASP ruleset
2. Implement MFA for sensitive operations
3. Encrypt all PII at rest

### Long-term (90 days)
1. Security awareness training
2. Penetration testing
3. Bug bounty program
```

### Template 2: STRIDE Analysis Code

```python
from dataclasses import dataclass, field
from enum import Enum
from typing import List, Dict, Optional
import json

class StrideCategory(Enum):
    SPOOFING = "S"
    TAMPERING = "T"
    REPUDIATION = "R"
    INFORMATION_DISCLOSURE = "I"
    DENIAL_OF_SERVICE = "D"
    ELEVATION_OF_PRIVILEGE = "E"


class Impact(Enum):
    LOW = 1
    MEDIUM = 2
    HIGH = 3
    CRITICAL = 4


class Likelihood(Enum):
    LOW = 1
    MEDIUM = 2
    HIGH = 3
    CRITICAL = 4


@dataclass
class Threat:
    id: str
    category: StrideCategory
    title: str
    description: str
    target: str
    impact: Impact
    likelihood: Likelihood
    mitigations: List[str] = field(default_factory=list)
    status: str = "open"

    @property
    def risk_score(self) -> int:
        return self.impact.value * self.likelihood.value

    @property
    def risk_level(self) -> str:
        score = self.risk_score
        if score >= 12:
            return "Critical"
        elif score >= 6:
            return "High"
        elif score >= 3:
            return "Medium"
        return "Low"


@dataclass
class Asset:
    name: str
    sensitivity: str
    description: str
    data_classification: str


@dataclass
class TrustBoundary:
    name: str
    description: str
    from_zone: str
    to_zone: str


@dataclass
class ThreatModel:
    name: str
    version: str
    description: str
    assets: List[Asset] = field(default_factory=list)
    boundaries: List[TrustBoundary] = field(default_factory=list)
    threats: List[Threat] = field(default_factory=list)

    def add_threat(self, threat: Threat) -> None:
        self.threats.append(threat)

    def get_threats_by_category(self, category: StrideCategory) -> List[Threat]:
        return [t for t in self.threats if t.category == category]

    def get_critical_threats(self) -> List[Threat]:
        return [t for t in self.threats if t.risk_level in ("Critical", "High")]

    def generate_report(self) -> Dict:
        """Generate threat model report."""
        return {
            "summary": {
                "name": self.name,
                "version": self.version,
                "total_threats": len(self.threats),
                "critical_threats": len([t for t in self.threats if t.risk_level == "Critical"]),
                "high_threats": len([t for t in self.threats if t.risk_level == "High"]),
            },
            "by_category": {
                cat.name: len(self.get_threats_by_category(cat))
                for cat in StrideCategory
            },
            "top_risks": [
                {
                    "id": t.id,
                    "title": t.title,
                    "risk_score": t.risk_score,
                    "risk_level": t.risk_level
                }
                for t in sorted(self.threats, key=lambda x: x.risk_score, reverse=True)[:10]
            ]
        }


class StrideAnalyzer:
    """Automated STRIDE analysis helper."""

    STRIDE_QUESTIONS = {
        StrideCategory.SPOOFING: [
            "Can an attacker impersonate a legitimate user?",
            "Are authentication tokens properly validated?",
            "Can session identifiers be predicted or stolen?",
            "Is multi-factor authentication available?",
        ],
        StrideCategory.TAMPERING: [
            "Can data be modified in transit?",
            "Can data be modified at rest?",
            "Are input validation controls sufficient?",
            "Can an attacker manipulate application logic?",
        ],
        StrideCategory.REPUDIATION: [
            "Are all security-relevant actions logged?",
            "Can logs be tampered with?",
            "Is there sufficient attribution for actions?",
            "Are timestamps reliable and synchronized?",
        ],
        StrideCategory.INFORMATION_DISCLOSURE: [
            "Is sensitive data encrypted at rest?",
            "Is sensitive data encrypted in transit?",
            "Can error messages reveal sensitive information?",
            "Are access controls properly enforced?",
        ],
        StrideCategory.DENIAL_OF_SERVICE: [
            "Are rate limits implemented?",
            "Can resources be exhausted by malicious input?",
            "Is there protection against amplification attacks?",
            "Are there single points of failure?",
        ],
        StrideCategory.ELEVATION_OF_PRIVILEGE: [
            "Are authorization checks performed consistently?",
            "Can users access other users' resources?",
            "Can privilege escalation occur through parameter manipulation?",
            "Is the principle of least privilege followed?",
        ],
    }

    def generate_questionnaire(self, component: str) -> List[Dict]:
        """Generate STRIDE questionnaire for a component."""
        questionnaire = []
        for category, questions in self.STRIDE_QUESTIONS.items():
            for q in questions:
                questionnaire.append({
                    "component": component,
                    "category": category.name,
                    "question": q,
                    "answer": None,
                    "notes": ""
                })
        return questionnaire

    def suggest_mitigations(self, category: StrideCategory) -> List[str]:
        """Suggest common mitigations for a STRIDE category."""
        mitigations = {
            StrideCategory.SPOOFING: [
                "Implement multi-factor authentication",
                "Use secure session management",
                "Implement account lockout policies",
                "Use cryptographically secure tokens",
                "Validate authentication at every request",
            ],
            StrideCategory.TAMPERING: [
                "Implement input validation",
                "Use parameterized queries",
                "Apply integrity checks (HMAC, signatures)",
                "Implement Content Security Policy",
                "Use immutable infrastructure",
            ],
            StrideCategory.REPUDIATION: [
                "Enable comprehensive audit logging",
                "Protect log integrity",
                "Implement digital signatures",
                "Use centralized, tamper-evident logging",
                "Maintain accurate timestamps",
            ],
            StrideCategory.INFORMATION_DISCLOSURE: [
                "Encrypt data at rest and in transit",
                "Implement proper access controls",
                "Sanitize error messages",
                "Use secure defaults",
                "Implement data classification",
            ],
            StrideCategory.DENIAL_OF_SERVICE: [
                "Implement rate limiting",
                "Use auto-scaling",
                "Deploy DDoS protection",
                "Implement circuit breakers",
                "Set resource quotas",
            ],
            StrideCategory.ELEVATION_OF_PRIVILEGE: [
                "Implement proper authorization",
                "Follow principle of least privilege",
                "Validate permissions server-side",
                "Use role-based access control",
                "Implement security boundaries",
            ],
        }
        return mitigations.get(category, [])
```

### Template 3: Data Flow Diagram Analysis

```python
from dataclasses import dataclass
from typing import List, Set, Tuple
from enum import Enum

class ElementType(Enum):
    EXTERNAL_ENTITY = "external"
    PROCESS = "process"
    DATA_STORE = "datastore"
    DATA_FLOW = "dataflow"


@dataclass
class DFDElement:
    id: str
    name: str
    type: ElementType
    trust_level: int  # 0 = untrusted, higher = more trusted
    description: str = ""


@dataclass
class DataFlow:
    id: str
    name: str
    source: str
    destination: str
    data_type: str
    protocol: str
    encrypted: bool = False


class DFDAnalyzer:
    """Analyze Data Flow Diagrams for STRIDE threats."""

    def __init__(self):
        self.elements: Dict[str, DFDElement] = {}
        self.flows: List[DataFlow] = []

    def add_element(self, element: DFDElement) -> None:
        self.elements[element.id] = element

    def add_flow(self, flow: DataFlow) -> None:
        self.flows.append(flow)

    def find_trust_boundary_crossings(self) -> List[Tuple[DataFlow, int]]:
        """Find data flows that cross trust boundaries."""
        crossings = []
        for flow in self.flows:
            source = self.elements.get(flow.source)
            dest = self.elements.get(flow.destination)
            if source and dest and source.trust_level != dest.trust_level:
                trust_diff = abs(source.trust_level - dest.trust_level)
                crossings.append((flow, trust_diff))
        return sorted(crossings, key=lambda x: x[1], reverse=True)

    def identify_threats_per_element(self) -> Dict[str, List[StrideCategory]]:
        """Map applicable STRIDE categories to element types."""
        threat_mapping = {
            ElementType.EXTERNAL_ENTITY: [
                StrideCategory.SPOOFING,
                StrideCategory.REPUDIATION,
            ],
            ElementType.PROCESS: [
                StrideCategory.SPOOFING,
                StrideCategory.TAMPERING,
                StrideCategory.REPUDIATION,
                StrideCategory.INFORMATION_DISCLOSURE,
                StrideCategory.DENIAL_OF_SERVICE,
                StrideCategory.ELEVATION_OF_PRIVILEGE,
            ],
            ElementType.DATA_STORE: [
                StrideCategory.TAMPERING,
                StrideCategory.REPUDIATION,
                StrideCategory.INFORMATION_DISCLOSURE,
                StrideCategory.DENIAL_OF_SERVICE,
            ],
            ElementType.DATA_FLOW: [
                StrideCategory.TAMPERING,
                StrideCategory.INFORMATION_DISCLOSURE,
                StrideCategory.DENIAL_OF_SERVICE,
            ],
        }

        result = {}
        for elem_id, elem in self.elements.items():
            result[elem_id] = threat_mapping.get(elem.type, [])
        return result

    def analyze_unencrypted_flows(self) -> List[DataFlow]:
        """Find unencrypted data flows crossing trust boundaries."""
        risky_flows = []
        for flow in self.flows:
            if not flow.encrypted:
                source = self.elements.get(flow.source)
                dest = self.elements.get(flow.destination)
                if source and dest and source.trust_level != dest.trust_level:
                    risky_flows.append(flow)
        return risky_flows

    def generate_threat_enumeration(self) -> List[Dict]:
        """Generate comprehensive threat enumeration."""
        threats = []
        element_threats = self.identify_threats_per_element()

        for elem_id, categories in element_threats.items():
            elem = self.elements[elem_id]
            for category in categories:
                threats.append({
                    "element_id": elem_id,
                    "element_name": elem.name,
                    "element_type": elem.type.value,
                    "stride_category": category.name,
                    "description": f"{category.name} threat against {elem.name}",
                    "trust_level": elem.trust_level
                })

        return threats
```

### Template 4: STRIDE per Interaction

```python
from typing import List, Dict, Optional
from dataclasses import dataclass

@dataclass
class Interaction:
    """Represents an interaction between two components."""
    id: str
    source: str
    target: str
    action: str
    data: str
    protocol: str


class StridePerInteraction:
    """Apply STRIDE to each interaction in the system."""

    INTERACTION_THREATS = {
        # Source type -> Target type -> Applicable threats
        ("external", "process"): {
            "S": "External entity spoofing identity to process",
            "T": "Tampering with data sent to process",
            "R": "External entity denying sending data",
            "I": "Data exposure during transmission",
            "D": "Flooding process with requests",
            "E": "Exploiting process to gain privileges",
        },
        ("process", "datastore"): {
            "T": "Process tampering with stored data",
            "R": "Process denying data modifications",
            "I": "Unauthorized data access by process",
            "D": "Process exhausting storage resources",
        },
        ("process", "process"): {
            "S": "Process spoofing another process",
            "T": "Tampering with inter-process data",
            "I": "Data leakage between processes",
            "D": "One process overwhelming another",
            "E": "Process gaining elevated access",
        },
    }

    def analyze_interaction(
        self,
        interaction: Interaction,
        source_type: str,
        target_type: str
    ) -> List[Dict]:
        """Analyze a single interaction for STRIDE threats."""
        threats = []
        key = (source_type, target_type)

        applicable_threats = self.INTERACTION_THREATS.get(key, {})

        for stride_code, description in applicable_threats.items():
            threats.append({
                "interaction_id": interaction.id,
                "source": interaction.source,
                "target": interaction.target,
                "stride_category": stride_code,
                "threat_description": description,
                "context": f"{interaction.action} - {interaction.data}",
            })

        return threats

    def generate_threat_matrix(
        self,
        interactions: List[Interaction],
        element_types: Dict[str, str]
    ) -> List[Dict]:
        """Generate complete threat matrix for all interactions."""
        all_threats = []

        for interaction in interactions:
            source_type = element_types.get(interaction.source, "unknown")
            target_type = element_types.get(interaction.target, "unknown")

            threats = self.analyze_interaction(
                interaction, source_type, target_type
            )
            all_threats.extend(threats)

        return all_threats
```

## Best Practices

### Do's

- **Involve stakeholders** - Security, dev, and ops perspectives
- **Be systematic** - Cover all STRIDE categories
- **Prioritize realistically** - Focus on high-impact threats
- **Update regularly** - Threat models are living documents
- **Use visual aids** - DFDs help communication

### Don'ts

- **Don't skip categories** - Each reveals different threats
- **Don't assume security** - Question every component
- **Don't work in isolation** - Collaborative modeling is better
- **Don't ignore low-probability** - High-impact threats matter
- **Don't stop at identification** - Follow through with mitigations

## Resources

- [Microsoft STRIDE Documentation](https://docs.microsoft.com/en-us/azure/security/develop/threat-modeling-tool-threats)
- [OWASP Threat Modeling](https://owasp.org/www-community/Threat_Modeling)
- [Threat Modeling: Designing for Security](https://www.wiley.com/en-us/Threat+Modeling%3A+Designing+for+Security-p-9781118809990)

## Threat Mitigation Mapping

# Threat Mitigation Mapping

Connect threats to controls for effective security planning.

## When to Use This Skill

- Prioritizing security investments
- Creating remediation roadmaps
- Validating control coverage
- Designing defense-in-depth
- Security architecture review
- Risk treatment planning

## Core Concepts

### 1. Control Categories

```
Preventive ────► Stop attacks before they occur
   │              (Firewall, Input validation)
   │
Detective ─────► Identify attacks in progress
   │              (IDS, Log monitoring)
   │
Corrective ────► Respond and recover from attacks
                  (Incident response, Backup restore)
```

### 2. Control Layers

| Layer           | Examples                             |
| --------------- | ------------------------------------ |
| **Network**     | Firewall, WAF, DDoS protection       |
| **Application** | Input validation, authentication     |
| **Data**        | Encryption, access controls          |
| **Endpoint**    | EDR, patch management                |
| **Process**     | Security training, incident response |

### 3. Defense in Depth

```
                    ┌──────────────────────┐
                    │      Perimeter       │ ← Firewall, WAF
                    │   ┌──────────────┐   │
                    │   │   Network    │   │ ← Segmentation, IDS
                    │   │  ┌────────┐  │   │
                    │   │  │  Host  │  │   │ ← EDR, Hardening
                    │   │  │ ┌────┐ │  │   │
                    │   │  │ │App │ │  │   │ ← Auth, Validation
                    │   │  │ │Data│ │  │   │ ← Encryption
                    │   │  │ └────┘ │  │   │
                    │   │  └────────┘  │   │
                    │   └──────────────┘   │
                    └──────────────────────┘
```

## Templates

### Template 1: Mitigation Model

```python
from dataclasses import dataclass, field
from enum import Enum
from typing import List, Dict, Optional, Set
from datetime import datetime

class ControlType(Enum):
    PREVENTIVE = "preventive"
    DETECTIVE = "detective"
    CORRECTIVE = "corrective"


class ControlLayer(Enum):
    NETWORK = "network"
    APPLICATION = "application"
    DATA = "data"
    ENDPOINT = "endpoint"
    PROCESS = "process"
    PHYSICAL = "physical"


class ImplementationStatus(Enum):
    NOT_IMPLEMENTED = "not_implemented"
    PARTIAL = "partial"
    IMPLEMENTED = "implemented"
    VERIFIED = "verified"


class Effectiveness(Enum):
    NONE = 0
    LOW = 1
    MEDIUM = 2
    HIGH = 3
    VERY_HIGH = 4


@dataclass
class SecurityControl:
    id: str
    name: str
    description: str
    control_type: ControlType
    layer: ControlLayer
    effectiveness: Effectiveness
    implementation_cost: str  # Low, Medium, High
    maintenance_cost: str
    status: ImplementationStatus = ImplementationStatus.NOT_IMPLEMENTED
    mitigates_threats: List[str] = field(default_factory=list)
    dependencies: List[str] = field(default_factory=list)
    technologies: List[str] = field(default_factory=list)
    compliance_refs: List[str] = field(default_factory=list)

    def coverage_score(self) -> float:
        """Calculate coverage score based on status and effectiveness."""
        status_multiplier = {
            ImplementationStatus.NOT_IMPLEMENTED: 0.0,
            ImplementationStatus.PARTIAL: 0.5,
            ImplementationStatus.IMPLEMENTED: 0.8,
            ImplementationStatus.VERIFIED: 1.0,
        }
        return self.effectiveness.value * status_multiplier[self.status]


@dataclass
class Threat:
    id: str
    name: str
    category: str  # STRIDE category
    description: str
    impact: str  # Critical, High, Medium, Low
    likelihood: str
    risk_score: float


@dataclass
class MitigationMapping:
    threat: Threat
    controls: List[SecurityControl]
    residual_risk: str = "Unknown"
    notes: str = ""

    def calculate_coverage(self) -> float:
        """Calculate how well controls cover the threat."""
        if not self.controls:
            return 0.0

        total_score = sum(c.coverage_score() for c in self.controls)
        max_possible = len(self.controls) * Effectiveness.VERY_HIGH.value

        return (total_score / max_possible) * 100 if max_possible > 0 else 0

    def has_defense_in_depth(self) -> bool:
        """Check if multiple layers are covered."""
        layers = set(c.layer for c in self.controls if c.status != ImplementationStatus.NOT_IMPLEMENTED)
        return len(layers) >= 2

    def has_control_diversity(self) -> bool:
        """Check if multiple control types are present."""
        types = set(c.control_type for c in self.controls if c.status != ImplementationStatus.NOT_IMPLEMENTED)
        return len(types) >= 2


@dataclass
class MitigationPlan:
    name: str
    threats: List[Threat] = field(default_factory=list)
    controls: List[SecurityControl] = field(default_factory=list)
    mappings: List[MitigationMapping] = field(default_factory=list)

    def get_unmapped_threats(self) -> List[Threat]:
        """Find threats without mitigations."""
        mapped_ids = {m.threat.id for m in self.mappings}
        return [t for t in self.threats if t.id not in mapped_ids]

    def get_control_coverage(self) -> Dict[str, float]:
        """Get coverage percentage for each threat."""
        return {
            m.threat.id: m.calculate_coverage()
            for m in self.mappings
        }

    def get_gaps(self) -> List[Dict]:
        """Identify mitigation gaps."""
        gaps = []
        for mapping in self.mappings:
            coverage = mapping.calculate_coverage()
            if coverage < 50:
                gaps.append({
                    "threat": mapping.threat.id,
                    "threat_name": mapping.threat.name,
                    "coverage": coverage,
                    "issue": "Insufficient control coverage",
                    "recommendation": "Add more controls or improve existing ones"
                })
            if not mapping.has_defense_in_depth():
                gaps.append({
                    "threat": mapping.threat.id,
                    "threat_name": mapping.threat.name,
                    "coverage": coverage,
                    "issue": "No defense in depth",
                    "recommendation": "Add controls at different layers"
                })
            if not mapping.has_control_diversity():
                gaps.append({
                    "threat": mapping.threat.id,
                    "threat_name": mapping.threat.name,
                    "coverage": coverage,
                    "issue": "No control diversity",
                    "recommendation": "Add detective/corrective controls"
                })
        return gaps
```

### Template 2: Control Library

```python
class ControlLibrary:
    """Library of standard security controls."""

    STANDARD_CONTROLS = {
        # Authentication Controls
        "AUTH-001": SecurityControl(
            id="AUTH-001",
            name="Multi-Factor Authentication",
            description="Require MFA for all user authentication",
            control_type=ControlType.PREVENTIVE,
            layer=ControlLayer.APPLICATION,
            effectiveness=Effectiveness.HIGH,
            implementation_cost="Medium",
            maintenance_cost="Low",
            mitigates_threats=["SPOOFING"],
            technologies=["TOTP", "WebAuthn", "SMS OTP"],
            compliance_refs=["PCI-DSS 8.3", "NIST 800-63B"]
        ),
        "AUTH-002": SecurityControl(
            id="AUTH-002",
            name="Account Lockout Policy",
            description="Lock accounts after failed authentication attempts",
            control_type=ControlType.PREVENTIVE,
            layer=ControlLayer.APPLICATION,
            effectiveness=Effectiveness.MEDIUM,
            implementation_cost="Low",
            maintenance_cost="Low",
            mitigates_threats=["SPOOFING"],
            technologies=["Custom implementation"],
            compliance_refs=["PCI-DSS 8.1.6"]
        ),

        # Input Validation Controls
        "VAL-001": SecurityControl(
            id="VAL-001",
            name="Input Validation Framework",
            description="Validate and sanitize all user input",
            control_type=ControlType.PREVENTIVE,
            layer=ControlLayer.APPLICATION,
            effectiveness=Effectiveness.HIGH,
            implementation_cost="Medium",
            maintenance_cost="Medium",
            mitigates_threats=["TAMPERING", "INJECTION"],
            technologies=["Joi", "Yup", "Pydantic"],
            compliance_refs=["OWASP ASVS V5"]
        ),
        "VAL-002": SecurityControl(
            id="VAL-002",
            name="Web Application Firewall",
            description="Deploy WAF to filter malicious requests",
            control_type=ControlType.PREVENTIVE,
            layer=ControlLayer.NETWORK,
            effectiveness=Effectiveness.MEDIUM,
            implementation_cost="Medium",
            maintenance_cost="Medium",
            mitigates_threats=["TAMPERING", "INJECTION", "DOS"],
            technologies=["AWS WAF", "Cloudflare", "ModSecurity"],
            compliance_refs=["PCI-DSS 6.6"]
        ),

        # Encryption Controls
        "ENC-001": SecurityControl(
            id="ENC-001",
            name="Data Encryption at Rest",
            description="Encrypt sensitive data in storage",
            control_type=ControlType.PREVENTIVE,
            layer=ControlLayer.DATA,
            effectiveness=Effectiveness.HIGH,
            implementation_cost="Medium",
            maintenance_cost="Low",
            mitigates_threats=["INFORMATION_DISCLOSURE"],
            technologies=["AES-256", "KMS", "HSM"],
            compliance_refs=["PCI-DSS 3.4", "GDPR Art. 32"]
        ),
        "ENC-002": SecurityControl(
            id="ENC-002",
            name="TLS Encryption",
            description="Encrypt data in transit using TLS 1.3",
            control_type=ControlType.PREVENTIVE,
            layer=ControlLayer.NETWORK,
            effectiveness=Effectiveness.HIGH,
            implementation_cost="Low",
            maintenance_cost="Low",
            mitigates_threats=["INFORMATION_DISCLOSURE", "TAMPERING"],
            technologies=["TLS 1.3", "Certificate management"],
            compliance_refs=["PCI-DSS 4.1", "HIPAA"]
        ),

        # Logging Controls
        "LOG-001": SecurityControl(
            id="LOG-001",
            name="Security Event Logging",
            description="Log all security-relevant events",
            control_type=ControlType.DETECTIVE,
            layer=ControlLayer.APPLICATION,
            effectiveness=Effectiveness.MEDIUM,
            implementation_cost="Low",
            maintenance_cost="Medium",
            mitigates_threats=["REPUDIATION"],
            technologies=["ELK Stack", "Splunk", "CloudWatch"],
            compliance_refs=["PCI-DSS 10.2", "SOC2"]
        ),
        "LOG-002": SecurityControl(
            id="LOG-002",
            name="Log Integrity Protection",
            description="Protect logs from tampering",
            control_type=ControlType.PREVENTIVE,
            layer=ControlLayer.DATA,
            effectiveness=Effectiveness.MEDIUM,
            implementation_cost="Medium",
            maintenance_cost="Low",
            mitigates_threats=["REPUDIATION", "TAMPERING"],
            technologies=["Immutable storage", "Log signing"],
            compliance_refs=["PCI-DSS 10.5"]
        ),

        # Access Control
        "ACC-001": SecurityControl(
            id="ACC-001",
            name="Role-Based Access Control",
            description="Implement RBAC for authorization",
            control_type=ControlType.PREVENTIVE,
            layer=ControlLayer.APPLICATION,
            effectiveness=Effectiveness.HIGH,
            implementation_cost="Medium",
            maintenance_cost="Medium",
            mitigates_threats=["ELEVATION_OF_PRIVILEGE", "INFORMATION_DISCLOSURE"],
            technologies=["RBAC", "ABAC", "Policy engines"],
            compliance_refs=["PCI-DSS 7.1", "SOC2"]
        ),

        # Availability Controls
        "AVL-001": SecurityControl(
            id="AVL-001",
            name="Rate Limiting",
            description="Limit request rates to prevent abuse",
            control_type=ControlType.PREVENTIVE,
            layer=ControlLayer.APPLICATION,
            effectiveness=Effectiveness.MEDIUM,
            implementation_cost="Low",
            maintenance_cost="Low",
            mitigates_threats=["DENIAL_OF_SERVICE"],
            technologies=["API Gateway", "Redis", "Token bucket"],
            compliance_refs=["OWASP API Security"]
        ),
        "AVL-002": SecurityControl(
            id="AVL-002",
            name="DDoS Protection",
            description="Deploy DDoS mitigation services",
            control_type=ControlType.PREVENTIVE,
            layer=ControlLayer.NETWORK,
            effectiveness=Effectiveness.HIGH,
            implementation_cost="High",
            maintenance_cost="Medium",
            mitigates_threats=["DENIAL_OF_SERVICE"],
            technologies=["Cloudflare", "AWS Shield", "Akamai"],
            compliance_refs=["NIST CSF"]
        ),
    }

    def get_controls_for_threat(self, threat_category: str) -> List[SecurityControl]:
        """Get all controls that mitigate a threat category."""
        return [
            c for c in self.STANDARD_CONTROLS.values()
            if threat_category in c.mitigates_threats
        ]

    def get_controls_by_layer(self, layer: ControlLayer) -> List[SecurityControl]:
        """Get controls for a specific layer."""
        return [c for c in self.STANDARD_CONTROLS.values() if c.layer == layer]

    def get_control(self, control_id: str) -> Optional[SecurityControl]:
        """Get a specific control by ID."""
        return self.STANDARD_CONTROLS.get(control_id)

    def recommend_controls(
        self,
        threat: Threat,
        existing_controls: List[str]
    ) -> List[SecurityControl]:
        """Recommend additional controls for a threat."""
        available = self.get_controls_for_threat(threat.category)
        return [c for c in available if c.id not in existing_controls]
```

### Template 3: Mitigation Analysis

```python
class MitigationAnalyzer:
    """Analyze and optimize mitigation strategies."""

    def __init__(self, plan: MitigationPlan, library: ControlLibrary):
        self.plan = plan
        self.library = library

    def calculate_overall_risk_reduction(self) -> float:
        """Calculate overall risk reduction percentage."""
        if not self.plan.mappings:
            return 0.0

        weighted_coverage = 0
        total_weight = 0

        for mapping in self.plan.mappings:
            # Weight by threat risk score
            weight = mapping.threat.risk_score
            coverage = mapping.calculate_coverage()
            weighted_coverage += weight * coverage
            total_weight += weight

        return weighted_coverage / total_weight if total_weight > 0 else 0

    def get_critical_gaps(self) -> List[Dict]:
        """Find critical gaps that need immediate attention."""
        gaps = self.plan.get_gaps()
        critical_threats = {t.id for t in self.plan.threats if t.impact == "Critical"}

        return [g for g in gaps if g["threat"] in critical_threats]

    def optimize_budget(
        self,
        budget: float,
        cost_map: Dict[str, float]
    ) -> List[SecurityControl]:
        """Select controls that maximize risk reduction within budget."""
        # Simple greedy approach - can be replaced with optimization algorithm
        recommended = []
        remaining_budget = budget
        unmapped = self.plan.get_unmapped_threats()

        # Sort controls by effectiveness/cost ratio
        all_controls = list(self.library.STANDARD_CONTROLS.values())
        controls_with_value = []

        for control in all_controls:
            if control.status == ImplementationStatus.NOT_IMPLEMENTED:
                cost = cost_map.get(control.id, float('inf'))
                if cost <= remaining_budget:
                    # Calculate value as threats covered * effectiveness / cost
                    threats_covered = len([
                        t for t in unmapped
                        if t.category in control.mitigates_threats
                    ])
                    if threats_covered > 0:
                        value = (threats_covered * control.effectiveness.value) / cost
                        controls_with_value.append((control, value, cost))

        # Sort by value (higher is better)
        controls_with_value.sort(key=lambda x: x[1], reverse=True)

        for control, value, cost in controls_with_value:
            if cost <= remaining_budget:
                recommended.append(control)
                remaining_budget -= cost

        return recommended

    def generate_roadmap(self) -> List[Dict]:
        """Generate implementation roadmap by priority."""
        roadmap = []
        gaps = self.plan.get_gaps()

        # Phase 1: Critical threats with low coverage
        phase1 = []
        for gap in gaps:
            mapping = next(
                (m for m in self.plan.mappings if m.threat.id == gap["threat"]),
                None
            )
            if mapping and mapping.threat.impact == "Critical":
                controls = self.library.get_controls_for_threat(mapping.threat.category)
                phase1.extend([
                    {
                        "threat": gap["threat"],
                        "control": c.id,
                        "control_name": c.name,
                        "phase": 1,
                        "priority": "Critical"
                    }
                    for c in controls
                    if c.status == ImplementationStatus.NOT_IMPLEMENTED
                ])

        roadmap.extend(phase1[:5])  # Top 5 for phase 1

        # Phase 2: High impact threats
        phase2 = []
        for gap in gaps:
            mapping = next(
                (m for m in self.plan.mappings if m.threat.id == gap["threat"]),
                None
            )
            if mapping and mapping.threat.impact == "High":
                controls = self.library.get_controls_for_threat(mapping.threat.category)
                phase2.extend([
                    {
                        "threat": gap["threat"],
                        "control": c.id,
                        "control_name": c.name,
                        "phase": 2,
                        "priority": "High"
                    }
                    for c in controls
                    if c.status == ImplementationStatus.NOT_IMPLEMENTED
                ])

        roadmap.extend(phase2[:5])  # Top 5 for phase 2

        return roadmap

    def defense_in_depth_analysis(self) -> Dict[str, List[str]]:
        """Analyze defense in depth coverage."""
        layer_coverage = {layer.value: [] for layer in ControlLayer}

        for mapping in self.plan.mappings:
            for control in mapping.controls:
                if control.status in [ImplementationStatus.IMPLEMENTED, ImplementationStatus.VERIFIED]:
                    layer_coverage[control.layer.value].append(control.id)

        return layer_coverage

    def generate_report(self) -> str:
        """Generate comprehensive mitigation report."""
        risk_reduction = self.calculate_overall_risk_reduction()
        gaps = self.plan.get_gaps()
        critical_gaps = self.get_critical_gaps()
        layer_coverage = self.defense_in_depth_analysis()

        report = f"""
# Threat Mitigation Report

## Executive Summary
- **Overall Risk Reduction:** {risk_reduction:.1f}%
- **Total Threats:** {len(self.plan.threats)}
- **Total Controls:** {len(self.plan.controls)}
- **Identified Gaps:** {len(gaps)}
- **Critical Gaps:** {len(critical_gaps)}

## Defense in Depth Coverage
{self._format_layer_coverage(layer_coverage)}

## Critical Gaps Requiring Immediate Action
{self._format_gaps(critical_gaps)}

## Recommendations
{self._format_recommendations()}

## Implementation Roadmap
{self._format_roadmap()}
"""
        return report

    def _format_layer_coverage(self, coverage: Dict[str, List[str]]) -> str:
        lines = []
        for layer, controls in coverage.items():
            status = "✓" if controls else "✗"
            lines.append(f"- {layer}: {status} ({len(controls)} controls)")
        return "\n".join(lines)

    def _format_gaps(self, gaps: List[Dict]) -> str:
        if not gaps:
            return "No critical gaps identified."
        lines = []
        for gap in gaps:
            lines.append(f"- **{gap['threat_name']}**: {gap['issue']}")
            lines.append(f"  - Coverage: {gap['coverage']:.1f}%")
            lines.append(f"  - Recommendation: {gap['recommendation']}")
        return "\n".join(lines)

    def _format_recommendations(self) -> str:
        recommendations = []
        layer_coverage = self.defense_in_depth_analysis()

        for layer, controls in layer_coverage.items():
            if not controls:
                recommendations.append(f"- Add {layer} layer controls")

        gaps = self.plan.get_gaps()
        if any(g["issue"] == "No control diversity" for g in gaps):
            recommendations.append("- Add more detective and corrective controls")

        return "\n".join(recommendations) if recommendations else "Current coverage is adequate."

    def _format_roadmap(self) -> str:
        roadmap = self.generate_roadmap()
        if not roadmap:
            return "No additional controls recommended at this time."

        lines = []
        current_phase = 0
        for item in roadmap:
            if item["phase"] != current_phase:
                current_phase = item["phase"]
                lines.append(f"\n### Phase {current_phase}")
            lines.append(f"- [{item['priority']}] {item['control_name']} (for {item['threat']})")

        return "\n".join(lines)
```

### Template 4: Control Effectiveness Testing

```python
from dataclasses import dataclass
from typing import List, Callable, Any
import asyncio

@dataclass
class ControlTest:
    control_id: str
    test_name: str
    test_function: Callable[[], bool]
    expected_result: bool
    description: str


class ControlTester:
    """Test control effectiveness."""

    def __init__(self):
        self.tests: List[ControlTest] = []
        self.results: List[Dict] = []

    def add_test(self, test: ControlTest) -> None:
        self.tests.append(test)

    async def run_tests(self) -> List[Dict]:
        """Run all control tests."""
        self.results = []

        for test in self.tests:
            try:
                result = test.test_function()
                passed = result == test.expected_result
                self.results.append({
                    "control_id": test.control_id,
                    "test_name": test.test_name,
                    "passed": passed,
                    "actual_result": result,
                    "expected_result": test.expected_result,
                    "description": test.description,
                    "error": None
                })
            except Exception as e:
                self.results.append({
                    "control_id": test.control_id,
                    "test_name": test.test_name,
                    "passed": False,
                    "actual_result": None,
                    "expected_result": test.expected_result,
                    "description": test.description,
                    "error": str(e)
                })

        return self.results

    def get_effectiveness_score(self, control_id: str) -> float:
        """Calculate effectiveness score for a control."""
        control_results = [r for r in self.results if r["control_id"] == control_id]
        if not control_results:
            return 0.0

        passed = sum(1 for r in control_results if r["passed"])
        return (passed / len(control_results)) * 100

    def generate_test_report(self) -> str:
        """Generate test results report."""
        if not self.results:
            return "No tests have been run."

        total = len(self.results)
        passed = sum(1 for r in self.results if r["passed"])

        report = f"""
# Control Effectiveness Test Report

## Summary
- **Total Tests:** {total}
- **Passed:** {passed}
- **Failed:** {total - passed}
- **Pass Rate:** {(passed/total)*100:.1f}%

## Results by Control
"""
        # Group by control
        controls = {}
        for result in self.results:
            cid = result["control_id"]
            if cid not in controls:
                controls[cid] = []
            controls[cid].append(result)

        for control_id, results in controls.items():
            score = self.get_effectiveness_score(control_id)
            report += f"\n### {control_id} (Effectiveness: {score:.1f}%)\n"
            for r in results:
                status = "✓" if r["passed"] else "✗"
                report += f"- {status} {r['test_name']}\n"
                if r["error"]:
                    report += f"  - Error: {r['error']}\n"

        return report
```

## Best Practices

### Do's

- **Map all threats** - No threat should be unmapped
- **Layer controls** - Defense in depth is essential
- **Mix control types** - Preventive, detective, corrective
- **Track effectiveness** - Measure and improve
- **Review regularly** - Controls degrade over time

### Don'ts

- **Don't rely on single controls** - Single points of failure
- **Don't ignore cost** - ROI matters
- **Don't skip testing** - Untested controls may fail
- **Don't set and forget** - Continuous improvement
- **Don't ignore people/process** - Technology alone isn't enough

## Resources

- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)
- [CIS Controls](https://www.cisecurity.org/controls)
- [MITRE D3FEND](https://d3fend.mitre.org/)
