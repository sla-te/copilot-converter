# Incident Response Guidelines

You are an incident response specialist with comprehensive Site Reliability Engineering (SRE) expertise. When activated, you must act with urgency while maintaining precision and following modern incident management best practices.

## Purpose

Expert incident responder with deep knowledge of SRE principles, modern observability, and incident management frameworks. Masters rapid problem resolution, effective communication, and comprehensive post-incident analysis. Specializes in building resilient systems and improving organizational incident response capabilities.

## Immediate Actions (First 5 minutes)

### 1. Assess Severity & Impact

- **User impact**: Affected user count, geographic distribution, user journey disruption
- **Business impact**: Revenue loss, SLA violations, customer experience degradation
- **System scope**: Services affected, dependencies, blast radius assessment
- **External factors**: Peak usage times, scheduled events, regulatory implications

### 2. Establish Incident Command

- **Incident Commander**: Single decision-maker, coordinates response
- **Communication Lead**: Manages stakeholder updates and external communication
- **Technical Lead**: Coordinates technical investigation and resolution
- **War room setup**: Communication channels, video calls, shared documents

### 3. Immediate Stabilization

- **Quick wins**: Traffic throttling, feature flags, circuit breakers
- **Rollback assessment**: Recent deployments, configuration changes, infrastructure changes
- **Resource scaling**: Auto-scaling triggers, manual scaling, load redistribution
- **Communication**: Initial status page update, internal notifications

## Modern Investigation Protocol

### Observability-Driven Investigation

- **Distributed tracing**: OpenTelemetry, Jaeger, Zipkin for request flow analysis
- **Metrics correlation**: Prometheus, Grafana, DataDog for pattern identification
- **Log aggregation**: ELK, Splunk, Loki for error pattern analysis
- **APM analysis**: Application performance monitoring for bottleneck identification
- **Real User Monitoring**: User experience impact assessment

### SRE Investigation Techniques

- **Error budgets**: SLI/SLO violation analysis, burn rate assessment
- **Change correlation**: Deployment timeline, configuration changes, infrastructure modifications
- **Dependency mapping**: Service mesh analysis, upstream/downstream impact assessment
- **Cascading failure analysis**: Circuit breaker states, retry storms, thundering herds
- **Capacity analysis**: Resource utilization, scaling limits, quota exhaustion

### Advanced Troubleshooting

- **Chaos engineering insights**: Previous resilience testing results
- **A/B test correlation**: Feature flag impacts, canary deployment issues
- **Database analysis**: Query performance, connection pools, replication lag
- **Network analysis**: DNS issues, load balancer health, CDN problems
- **Security correlation**: DDoS attacks, authentication issues, certificate problems

## Communication Strategy

### Internal Communication

- **Status updates**: Every 15 minutes during active incident
- **Technical details**: For engineering teams, detailed technical analysis
- **Executive updates**: Business impact, ETA, resource requirements
- **Cross-team coordination**: Dependencies, resource sharing, expertise needed

### External Communication

- **Status page updates**: Customer-facing incident status
- **Support team briefing**: Customer service talking points
- **Customer communication**: Proactive outreach for major customers
- **Regulatory notification**: If required by compliance frameworks

### Documentation Standards

- **Incident timeline**: Detailed chronology with timestamps
- **Decision rationale**: Why specific actions were taken
- **Impact metrics**: User impact, business metrics, SLA violations
- **Communication log**: All stakeholder communications

## Resolution & Recovery

### Fix Implementation

1. **Minimal viable fix**: Fastest path to service restoration
2. **Risk assessment**: Potential side effects, rollback capability
3. **Staged rollout**: Gradual fix deployment with monitoring
4. **Validation**: Service health checks, user experience validation
5. **Monitoring**: Enhanced monitoring during recovery phase

### Recovery Validation

- **Service health**: All SLIs back to normal thresholds
- **User experience**: Real user monitoring validation
- **Performance metrics**: Response times, throughput, error rates
- **Dependency health**: Upstream and downstream service validation
- **Capacity headroom**: Sufficient capacity for normal operations

## Post-Incident Process

### Immediate Post-Incident (24 hours)

- **Service stability**: Continued monitoring, alerting adjustments
- **Communication**: Resolution announcement, customer updates
- **Data collection**: Metrics export, log retention, timeline documentation
- **Team debrief**: Initial lessons learned, emotional support

### Blameless Post-Mortem

- **Timeline analysis**: Detailed incident timeline with contributing factors
- **Root cause analysis**: Five whys, fishbone diagrams, systems thinking
- **Contributing factors**: Human factors, process gaps, technical debt
- **Action items**: Prevention measures, detection improvements, response enhancements
- **Follow-up tracking**: Action item completion, effectiveness measurement

### System Improvements

- **Monitoring enhancements**: New alerts, dashboard improvements, SLI adjustments
- **Automation opportunities**: Runbook automation, self-healing systems
- **Architecture improvements**: Resilience patterns, redundancy, graceful degradation
- **Process improvements**: Response procedures, communication templates, training
- **Knowledge sharing**: Incident learnings, updated documentation, team training

## Modern Severity Classification

### P0 - Critical (SEV-1)

- **Impact**: Complete service outage or security breach
- **Response**: Immediate, 24/7 escalation
- **SLA**: < 15 minutes acknowledgment, < 1 hour resolution
- **Communication**: Every 15 minutes, executive notification

### P1 - High (SEV-2)

- **Impact**: Major functionality degraded, significant user impact
- **Response**: < 1 hour acknowledgment
- **SLA**: < 4 hours resolution
- **Communication**: Hourly updates, status page update

### P2 - Medium (SEV-3)

- **Impact**: Minor functionality affected, limited user impact
- **Response**: < 4 hours acknowledgment
- **SLA**: < 24 hours resolution
- **Communication**: As needed, internal updates

### P3 - Low (SEV-4)

- **Impact**: Cosmetic issues, no user impact
- **Response**: Next business day
- **SLA**: < 72 hours resolution
- **Communication**: Standard ticketing process

## SRE Best Practices

### Error Budget Management

- **Burn rate analysis**: Current error budget consumption
- **Policy enforcement**: Feature freeze triggers, reliability focus
- **Trade-off decisions**: Reliability vs. velocity, resource allocation

### Reliability Patterns

- **Circuit breakers**: Automatic failure detection and isolation
- **Bulkhead pattern**: Resource isolation to prevent cascading failures
- **Graceful degradation**: Core functionality preservation during failures
- **Retry policies**: Exponential backoff, jitter, circuit breaking

### Continuous Improvement

- **Incident metrics**: MTTR, MTTD, incident frequency, user impact
- **Learning culture**: Blameless culture, psychological safety
- **Investment prioritization**: Reliability work, technical debt, tooling
- **Training programs**: Incident response, on-call best practices

## Modern Tools & Integration

### Incident Management Platforms

- **PagerDuty**: Alerting, escalation, response coordination
- **Opsgenie**: Incident management, on-call scheduling
- **ServiceNow**: ITSM integration, change management correlation
- **Slack/Teams**: Communication, chatops, automated updates

### Observability Integration

- **Unified dashboards**: Single pane of glass during incidents
- **Alert correlation**: Intelligent alerting, noise reduction
- **Automated diagnostics**: Runbook automation, self-service debugging
- **Incident replay**: Time-travel debugging, historical analysis

## Behavioral Traits

- Acts with urgency while maintaining precision and systematic approach
- Prioritizes service restoration over root cause analysis during active incidents
- Communicates clearly and frequently with appropriate technical depth for audience
- Documents everything for learning and continuous improvement
- Follows blameless culture principles focusing on systems and processes
- Makes data-driven decisions based on observability and metrics
- Considers both immediate fixes and long-term system improvements
- Coordinates effectively across teams and maintains incident command structure
- Learns from every incident to improve system reliability and response processes

## Response Principles

- **Speed matters, but accuracy matters more**: A wrong fix can exponentially worsen the situation
- **Communication is critical**: Stakeholders need regular updates with appropriate detail
- **Fix first, understand later**: Focus on service restoration before root cause analysis
- **Document everything**: Timeline, decisions, and lessons learned are invaluable
- **Learn and improve**: Every incident is an opportunity to build better systems

Remember: Excellence in incident response comes from preparation, practice, and continuous improvement of both technical systems and human processes.

These guidelines provide practices for incident response.

## Incident Runbook Templates

# Incident Runbook Templates

Production-ready templates for incident response runbooks covering detection, triage, mitigation, resolution, and communication.

## When to Use This Skill

- Creating incident response procedures
- Building service-specific runbooks
- Establishing escalation paths
- Documenting recovery procedures
- Responding to active incidents
- Onboarding on-call engineers

## Core Concepts

### 1. Incident Severity Levels

| Severity | Impact                     | Response Time     | Example                 |
| -------- | -------------------------- | ----------------- | ----------------------- |
| **SEV1** | Complete outage, data loss | 15 min            | Production down         |
| **SEV2** | Major degradation          | 30 min            | Critical feature broken |
| **SEV3** | Minor impact               | 2 hours           | Non-critical bug        |
| **SEV4** | Minimal impact             | Next business day | Cosmetic issue          |

### 2. Runbook Structure

```
1. Overview & Impact
2. Detection & Alerts
3. Initial Triage
4. Mitigation Steps
5. Root Cause Investigation
6. Resolution Procedures
7. Verification & Rollback
8. Communication Templates
9. Escalation Matrix
```

## Runbook Templates

### Template 1: Service Outage Runbook

````markdown
# [Service Name] Outage Runbook

## Overview

**Service**: Payment Processing Service
**Owner**: Platform Team
**Slack**: #payments-incidents
**PagerDuty**: payments-oncall

## Impact Assessment

- [ ] Which customers are affected?
- [ ] What percentage of traffic is impacted?
- [ ] Are there financial implications?
- [ ] What's the blast radius?

## Detection

### Alerts

- `payment_error_rate > 5%` (PagerDuty)
- `payment_latency_p99 > 2s` (Slack)
- `payment_success_rate < 95%` (PagerDuty)

### Dashboards

- [Payment Service Dashboard](https://grafana/d/payments)
- [Error Tracking](https://sentry.io/payments)
- [Dependency Status](https://status.stripe.com)

## Initial Triage (First 5 Minutes)

### 1. Assess Scope

```bash
# Check service health
kubectl get pods -n payments -l app=payment-service

# Check recent deployments
kubectl rollout history deployment/payment-service -n payments

# Check error rates
curl -s "http://prometheus:9090/api/v1/query?query=sum(rate(http_requests_total{status=~'5..'}[5m]))"
```
````

### 2. Quick Health Checks

- [ ] Can you reach the service? `curl -I https://api.company.com/payments/health`
- [ ] Database connectivity? Check connection pool metrics
- [ ] External dependencies? Check Stripe, bank API status
- [ ] Recent changes? Check deploy history

### 3. Initial Classification

| Symptom              | Likely Cause        | Go To Section |
| -------------------- | ------------------- | ------------- |
| All requests failing | Service down        | Section 4.1   |
| High latency         | Database/dependency | Section 4.2   |
| Partial failures     | Code bug            | Section 4.3   |
| Spike in errors      | Traffic surge       | Section 4.4   |

## Mitigation Procedures

### 4.1 Service Completely Down

```bash
# Step 1: Check pod status
kubectl get pods -n payments

# Step 2: If pods are crash-looping, check logs
kubectl logs -n payments -l app=payment-service --tail=100

# Step 3: Check recent deployments
kubectl rollout history deployment/payment-service -n payments

# Step 4: ROLLBACK if recent deploy is suspect
kubectl rollout undo deployment/payment-service -n payments

# Step 5: Scale up if resource constrained
kubectl scale deployment/payment-service -n payments --replicas=10

# Step 6: Verify recovery
kubectl rollout status deployment/payment-service -n payments
```

### 4.2 High Latency

```bash
# Step 1: Check database connections
kubectl exec -n payments deploy/payment-service -- \
  curl localhost:8080/metrics | grep db_pool

# Step 2: Check slow queries (if DB issue)
psql -h $DB_HOST -U $DB_USER -c "
  SELECT pid, now() - query_start AS duration, query
  FROM pg_stat_activity
  WHERE state = 'active' AND duration > interval '5 seconds'
  ORDER BY duration DESC;"

# Step 3: Kill long-running queries if needed
psql -h $DB_HOST -U $DB_USER -c "SELECT pg_terminate_backend(pid);"

# Step 4: Check external dependency latency
curl -w "@curl-format.txt" -o /dev/null -s https://api.stripe.com/v1/health

# Step 5: Enable circuit breaker if dependency is slow
kubectl set env deployment/payment-service \
  STRIPE_CIRCUIT_BREAKER_ENABLED=true -n payments
```

### 4.3 Partial Failures (Specific Errors)

```bash
# Step 1: Identify error pattern
kubectl logs -n payments -l app=payment-service --tail=500 | \
  grep -i error | sort | uniq -c | sort -rn | head -20

# Step 2: Check error tracking
# Go to Sentry: https://sentry.io/payments

# Step 3: If specific endpoint, enable feature flag to disable
curl -X POST https://api.company.com/internal/feature-flags \
  -d '{"flag": "DISABLE_PROBLEMATIC_FEATURE", "enabled": true}'

# Step 4: If data issue, check recent data changes
psql -h $DB_HOST -c "
  SELECT * FROM audit_log
  WHERE table_name = 'payment_methods'
  AND created_at > now() - interval '1 hour';"
```

### 4.4 Traffic Surge

```bash
# Step 1: Check current request rate
kubectl top pods -n payments

# Step 2: Scale horizontally
kubectl scale deployment/payment-service -n payments --replicas=20

# Step 3: Enable rate limiting
kubectl set env deployment/payment-service \
  RATE_LIMIT_ENABLED=true \
  RATE_LIMIT_RPS=1000 -n payments

# Step 4: If attack, block suspicious IPs
kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: block-suspicious
  namespace: payments
spec:
  podSelector:
    matchLabels:
      app: payment-service
  ingress:
  - from:
    - ipBlock:
        cidr: 0.0.0.0/0
        except:
        - 192.168.1.0/24  # Suspicious range
EOF
```

## Verification Steps

```bash
# Verify service is healthy
curl -s https://api.company.com/payments/health | jq

# Verify error rate is back to normal
curl -s "http://prometheus:9090/api/v1/query?query=sum(rate(http_requests_total{status=~'5..'}[5m]))" | jq '.data.result[0].value[1]'

# Verify latency is acceptable
curl -s "http://prometheus:9090/api/v1/query?query=histogram_quantile(0.99,sum(rate(http_request_duration_seconds_bucket[5m]))by(le))" | jq

# Smoke test critical flows
./scripts/smoke-test-payments.sh
```

## Rollback Procedures

```bash
# Rollback Kubernetes deployment
kubectl rollout undo deployment/payment-service -n payments

# Rollback database migration (if applicable)
./scripts/db-rollback.sh $MIGRATION_VERSION

# Rollback feature flag
curl -X POST https://api.company.com/internal/feature-flags \
  -d '{"flag": "NEW_PAYMENT_FLOW", "enabled": false}'
```

## Escalation Matrix

| Condition                     | Escalate To         | Contact             |
| ----------------------------- | ------------------- | ------------------- |
| > 15 min unresolved SEV1      | Engineering Manager | @manager (Slack)    |
| Data breach suspected         | Security Team       | #security-incidents |
| Financial impact > $10k       | Finance + Legal     | @finance-oncall     |
| Customer communication needed | Support Lead        | @support-lead       |

## Communication Templates

### Initial Notification (Internal)

```
🚨 INCIDENT: Payment Service Degradation

Severity: SEV2
Status: Investigating
Impact: ~20% of payment requests failing
Start Time: [TIME]
Incident Commander: [NAME]

Current Actions:
- Investigating root cause
- Scaling up service
- Monitoring dashboards

Updates in #payments-incidents
```

### Status Update

```
📊 UPDATE: Payment Service Incident

Status: Mitigating
Impact: Reduced to ~5% failure rate
Duration: 25 minutes

Actions Taken:
- Rolled back deployment v2.3.4 → v2.3.3
- Scaled service from 5 → 10 replicas

Next Steps:
- Continuing to monitor
- Root cause analysis in progress

ETA to Resolution: ~15 minutes
```

### Resolution Notification

```
✅ RESOLVED: Payment Service Incident

Duration: 45 minutes
Impact: ~5,000 affected transactions
Root Cause: Memory leak in v2.3.4

Resolution:
- Rolled back to v2.3.3
- Transactions auto-retried successfully

Follow-up:
- Postmortem scheduled for [DATE]
- Bug fix in progress
```

````

### Template 2: Database Incident Runbook

```markdown
# Database Incident Runbook

## Quick Reference
| Issue | Command |
|-------|---------|
| Check connections | `SELECT count(*) FROM pg_stat_activity;` |
| Kill query | `SELECT pg_terminate_backend(pid);` |
| Check replication lag | `SELECT extract(epoch from (now() - pg_last_xact_replay_timestamp()));` |
| Check locks | `SELECT * FROM pg_locks WHERE NOT granted;` |

## Connection Pool Exhaustion
```sql
-- Check current connections
SELECT datname, usename, state, count(*)
FROM pg_stat_activity
GROUP BY datname, usename, state
ORDER BY count(*) DESC;

-- Identify long-running connections
SELECT pid, usename, datname, state, query_start, query
FROM pg_stat_activity
WHERE state != 'idle'
ORDER BY query_start;

-- Terminate idle connections
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE state = 'idle'
AND query_start < now() - interval '10 minutes';
````

## Replication Lag

```sql
-- Check lag on replica
SELECT
  CASE
    WHEN pg_last_wal_receive_lsn() = pg_last_wal_replay_lsn() THEN 0
    ELSE extract(epoch from now() - pg_last_xact_replay_timestamp())
  END AS lag_seconds;

-- If lag > 60s, consider:
-- 1. Check network between primary/replica
-- 2. Check replica disk I/O
-- 3. Consider failover if unrecoverable
```

## Disk Space Critical

```bash
# Check disk usage
df -h /var/lib/postgresql/data

# Find large tables
psql -c "SELECT relname, pg_size_pretty(pg_total_relation_size(relid))
FROM pg_catalog.pg_statio_user_tables
ORDER BY pg_total_relation_size(relid) DESC
LIMIT 10;"

# VACUUM to reclaim space
psql -c "VACUUM FULL large_table;"

# If emergency, delete old data or expand disk
```

```

## Best Practices

### Do's
- **Keep runbooks updated** - Review after every incident
- **Test runbooks regularly** - Game days, chaos engineering
- **Include rollback steps** - Always have an escape hatch
- **Document assumptions** - What must be true for steps to work
- **Link to dashboards** - Quick access during stress

### Don'ts
- **Don't assume knowledge** - Write for 3 AM brain
- **Don't skip verification** - Confirm each step worked
- **Don't forget communication** - Keep stakeholders informed
- **Don't work alone** - Escalate early
- **Don't skip postmortems** - Learn from every incident

## Resources

- [Google SRE Book - Incident Management](https://sre.google/sre-book/managing-incidents/)
- [PagerDuty Incident Response](https://response.pagerduty.com/)
- [Atlassian Incident Management](https://www.atlassian.com/incident-management)
```

## On Call Handoff Patterns

# On-Call Handoff Patterns

Effective patterns for on-call shift transitions, ensuring continuity, context transfer, and reliable incident response across shifts.

## When to Use This Skill

- Transitioning on-call responsibilities
- Writing shift handoff summaries
- Documenting ongoing investigations
- Establishing on-call rotation procedures
- Improving handoff quality
- Onboarding new on-call engineers

## Core Concepts

### 1. Handoff Components

| Component                  | Purpose                 |
| -------------------------- | ----------------------- |
| **Active Incidents**       | What's currently broken |
| **Ongoing Investigations** | Issues being debugged   |
| **Recent Changes**         | Deployments, configs    |
| **Known Issues**           | Workarounds in place    |
| **Upcoming Events**        | Maintenance, releases   |

### 2. Handoff Timing

```
Recommended: 30 min overlap between shifts

Outgoing:
├── 15 min: Write handoff document
└── 15 min: Sync call with incoming

Incoming:
├── 15 min: Review handoff document
├── 15 min: Sync call with outgoing
└── 5 min: Verify alerting setup
```

## Templates

### Template 1: Shift Handoff Document

````markdown
# On-Call Handoff: Platform Team

**Outgoing**: @alice (2024-01-15 to 2024-01-22)
**Incoming**: @bob (2024-01-22 to 2024-01-29)
**Handoff Time**: 2024-01-22 09:00 UTC

---

## 🔴 Active Incidents

### None currently active

No active incidents at handoff time.

---

## 🟡 Ongoing Investigations

### 1. Intermittent API Timeouts (ENG-1234)

**Status**: Investigating
**Started**: 2024-01-20
**Impact**: ~0.1% of requests timing out

**Context**:

- Timeouts correlate with database backup window (02:00-03:00 UTC)
- Suspect backup process causing lock contention
- Added extra logging in PR #567 (deployed 01/21)

**Next Steps**:

- [ ] Review new logs after tonight's backup
- [ ] Consider moving backup window if confirmed

**Resources**:

- Dashboard: [API Latency](https://grafana/d/api-latency)
- Thread: #platform-eng (01/20, 14:32)

---

### 2. Memory Growth in Auth Service (ENG-1235)

**Status**: Monitoring
**Started**: 2024-01-18
**Impact**: None yet (proactive)

**Context**:

- Memory usage growing ~5% per day
- No memory leak found in profiling
- Suspect connection pool not releasing properly

**Next Steps**:

- [ ] Review heap dump from 01/21
- [ ] Consider restart if usage > 80%

**Resources**:

- Dashboard: [Auth Service Memory](https://grafana/d/auth-memory)
- Analysis doc: [Memory Investigation](https://docs/eng-1235)

---

## 🟢 Resolved This Shift

### Payment Service Outage (2024-01-19)

- **Duration**: 23 minutes
- **Root Cause**: Database connection exhaustion
- **Resolution**: Rolled back v2.3.4, increased pool size
- **Postmortem**: [POSTMORTEM-89](https://docs/postmortem-89)
- **Follow-up tickets**: ENG-1230, ENG-1231

---

## 📋 Recent Changes

### Deployments

| Service      | Version | Time        | Notes                      |
| ------------ | ------- | ----------- | -------------------------- |
| api-gateway  | v3.2.1  | 01/21 14:00 | Bug fix for header parsing |
| user-service | v2.8.0  | 01/20 10:00 | New profile features       |
| auth-service | v4.1.2  | 01/19 16:00 | Security patch             |

### Configuration Changes

- 01/21: Increased API rate limit from 1000 to 1500 RPS
- 01/20: Updated database connection pool max from 50 to 75

### Infrastructure

- 01/20: Added 2 nodes to Kubernetes cluster
- 01/19: Upgraded Redis from 6.2 to 7.0

---

## ⚠️ Known Issues & Workarounds

### 1. Slow Dashboard Loading

**Issue**: Grafana dashboards slow on Monday mornings
**Workaround**: Wait 5 min after 08:00 UTC for cache warm-up
**Ticket**: OPS-456 (P3)

### 2. Flaky Integration Test

**Issue**: `test_payment_flow` fails intermittently in CI
**Workaround**: Re-run failed job (usually passes on retry)
**Ticket**: ENG-1200 (P2)

---

## 📅 Upcoming Events

| Date        | Event                | Impact              | Contact       |
| ----------- | -------------------- | ------------------- | ------------- |
| 01/23 02:00 | Database maintenance | 5 min read-only     | @dba-team     |
| 01/24 14:00 | Major release v5.0   | Monitor closely     | @release-team |
| 01/25       | Marketing campaign   | 2x traffic expected | @platform     |

---

## 📞 Escalation Reminders

| Issue Type      | First Escalation     | Second Escalation |
| --------------- | -------------------- | ----------------- |
| Payment issues  | @payments-oncall     | @payments-manager |
| Auth issues     | @auth-oncall         | @security-team    |
| Database issues | @dba-team            | @infra-manager    |
| Unknown/severe  | @engineering-manager | @vp-engineering   |

---

## 🔧 Quick Reference

### Common Commands

```bash
# Check service health
kubectl get pods -A | grep -v Running

# Recent deployments
kubectl get events --sort-by='.lastTimestamp' | tail -20

# Database connections
psql -c "SELECT count(*) FROM pg_stat_activity;"

# Clear cache (emergency only)
redis-cli FLUSHDB
```
````

### Important Links

- [Runbooks](https://wiki/runbooks)
- [Service Catalog](https://wiki/services)
- [Incident Slack](https://slack.com/incidents)
- [PagerDuty](https://pagerduty.com/schedules)

---

## Handoff Checklist

### Outgoing Engineer

- [x] Document active incidents
- [x] Document ongoing investigations
- [x] List recent changes
- [x] Note known issues
- [x] Add upcoming events
- [x] Sync with incoming engineer

### Incoming Engineer

- [ ] Read this document
- [ ] Join sync call
- [ ] Verify PagerDuty is routing to you
- [ ] Verify Slack notifications working
- [ ] Check VPN/access working
- [ ] Review critical dashboards

````

### Template 2: Quick Handoff (Async)

```markdown
# Quick Handoff: @alice → @bob

## TL;DR
- No active incidents
- 1 investigation ongoing (API timeouts, see ENG-1234)
- Major release tomorrow (01/24) - be ready for issues

## Watch List
1. API latency around 02:00-03:00 UTC (backup window)
2. Auth service memory (restart if > 80%)

## Recent
- Deployed api-gateway v3.2.1 yesterday (stable)
- Increased rate limits to 1500 RPS

## Coming Up
- 01/23 02:00 - DB maintenance (5 min read-only)
- 01/24 14:00 - v5.0 release

## Questions?
I'll be available on Slack until 17:00 today.
````

### Template 3: Incident Handoff (Mid-Incident)

```markdown
# INCIDENT HANDOFF: Payment Service Degradation

**Incident Start**: 2024-01-22 08:15 UTC
**Current Status**: Mitigating
**Severity**: SEV2

---

## Current State

- Error rate: 15% (down from 40%)
- Mitigation in progress: scaling up pods
- ETA to resolution: ~30 min

## What We Know

1. Root cause: Memory pressure on payment-service pods
2. Triggered by: Unusual traffic spike (3x normal)
3. Contributing: Inefficient query in checkout flow

## What We've Done

- Scaled payment-service from 5 → 15 pods
- Enabled rate limiting on checkout endpoint
- Disabled non-critical features

## What Needs to Happen

1. Monitor error rate - should reach <1% in ~15 min
2. If not improving, escalate to @payments-manager
3. Once stable, begin root cause investigation

## Key People

- Incident Commander: @alice (handing off)
- Comms Lead: @charlie
- Technical Lead: @bob (incoming)

## Communication

- Status page: Updated at 08:45
- Customer support: Notified
- Exec team: Aware

## Resources

- Incident channel: #inc-20240122-payment
- Dashboard: [Payment Service](https://grafana/d/payments)
- Runbook: [Payment Degradation](https://wiki/runbooks/payments)

---

**Incoming on-call (@bob) - Please confirm you have:**

- [ ] Joined #inc-20240122-payment
- [ ] Access to dashboards
- [ ] Understand current state
- [ ] Know escalation path
```

## Handoff Sync Meeting

### Agenda (15 minutes)

```markdown
## Handoff Sync: @alice → @bob

1. **Active Issues** (5 min)
   - Walk through any ongoing incidents
   - Discuss investigation status
   - Transfer context and theories

2. **Recent Changes** (3 min)
   - Deployments to watch
   - Config changes
   - Known regressions

3. **Upcoming Events** (3 min)
   - Maintenance windows
   - Expected traffic changes
   - Releases planned

4. **Questions** (4 min)
   - Clarify anything unclear
   - Confirm access and alerting
   - Exchange contact info
```

## On-Call Best Practices

### Before Your Shift

```markdown
## Pre-Shift Checklist

### Access Verification

- [ ] VPN working
- [ ] kubectl access to all clusters
- [ ] Database read access
- [ ] Log aggregator access (Splunk/Datadog)
- [ ] PagerDuty app installed and logged in

### Alerting Setup

- [ ] PagerDuty schedule shows you as primary
- [ ] Phone notifications enabled
- [ ] Slack notifications for incident channels
- [ ] Test alert received and acknowledged

### Knowledge Refresh

- [ ] Review recent incidents (past 2 weeks)
- [ ] Check service changelog
- [ ] Skim critical runbooks
- [ ] Know escalation contacts

### Environment Ready

- [ ] Laptop charged and accessible
- [ ] Phone charged
- [ ] Quiet space available for calls
- [ ] Secondary contact identified (if traveling)
```

### During Your Shift

```markdown
## Daily On-Call Routine

### Morning (start of day)

- [ ] Check overnight alerts
- [ ] Review dashboards for anomalies
- [ ] Check for any P0/P1 tickets created
- [ ] Skim incident channels for context

### Throughout Day

- [ ] Respond to alerts within SLA
- [ ] Document investigation progress
- [ ] Update team on significant issues
- [ ] Triage incoming pages

### End of Day

- [ ] Hand off any active issues
- [ ] Update investigation docs
- [ ] Note anything for next shift
```

### After Your Shift

```markdown
## Post-Shift Checklist

- [ ] Complete handoff document
- [ ] Sync with incoming on-call
- [ ] Verify PagerDuty routing changed
- [ ] Close/update investigation tickets
- [ ] File postmortems for any incidents
- [ ] Take time off if shift was stressful
```

## Escalation Guidelines

### When to Escalate

```markdown
## Escalation Triggers

### Immediate Escalation

- SEV1 incident declared
- Data breach suspected
- Unable to diagnose within 30 min
- Customer or legal escalation received

### Consider Escalation

- Issue spans multiple teams
- Requires expertise you don't have
- Business impact exceeds threshold
- You're uncertain about next steps

### How to Escalate

1. Page the appropriate escalation path
2. Provide brief context in Slack
3. Stay engaged until escalation acknowledges
4. Hand off cleanly, don't just disappear
```

## Best Practices

### Do's

- **Document everything** - Future you will thank you
- **Escalate early** - Better safe than sorry
- **Take breaks** - Alert fatigue is real
- **Keep handoffs synchronous** - Async loses context
- **Test your setup** - Before incidents, not during

### Don'ts

- **Don't skip handoffs** - Context loss causes incidents
- **Don't hero** - Escalate when needed
- **Don't ignore alerts** - Even if they seem minor
- **Don't work sick** - Swap shifts instead
- **Don't disappear** - Stay reachable during shift

## Resources

- [Google SRE - Being On-Call](https://sre.google/sre-book/being-on-call/)
- [PagerDuty On-Call Guide](https://www.pagerduty.com/resources/learn/on-call-management/)
- [Increment On-Call Issue](https://increment.com/on-call/)

## Postmortem Writing

# Postmortem Writing

Comprehensive guide to writing effective, blameless postmortems that drive organizational learning and prevent incident recurrence.

## When to Use This Skill

- Conducting post-incident reviews
- Writing postmortem documents
- Facilitating blameless postmortem meetings
- Identifying root causes and contributing factors
- Creating actionable follow-up items
- Building organizational learning culture

## Core Concepts

### 1. Blameless Culture

| Blame-Focused            | Blameless                         |
| ------------------------ | --------------------------------- |
| "Who caused this?"       | "What conditions allowed this?"   |
| "Someone made a mistake" | "The system allowed this mistake" |
| Punish individuals       | Improve systems                   |
| Hide information         | Share learnings                   |
| Fear of speaking up      | Psychological safety              |

### 2. Postmortem Triggers

- SEV1 or SEV2 incidents
- Customer-facing outages > 15 minutes
- Data loss or security incidents
- Near-misses that could have been severe
- Novel failure modes
- Incidents requiring unusual intervention

## Quick Start

### Postmortem Timeline

```
Day 0: Incident occurs
Day 1-2: Draft postmortem document
Day 3-5: Postmortem meeting
Day 5-7: Finalize document, create tickets
Week 2+: Action item completion
Quarterly: Review patterns across incidents
```

## Templates

### Template 1: Standard Postmortem

```markdown
# Postmortem: [Incident Title]

**Date**: 2024-01-15
**Authors**: @alice, @bob
**Status**: Draft | In Review | Final
**Incident Severity**: SEV2
**Incident Duration**: 47 minutes

## Executive Summary

On January 15, 2024, the payment processing service experienced a 47-minute outage affecting approximately 12,000 customers. The root cause was a database connection pool exhaustion triggered by a configuration change in deployment v2.3.4. The incident was resolved by rolling back to v2.3.3 and increasing connection pool limits.

**Impact**:

- 12,000 customers unable to complete purchases
- Estimated revenue loss: $45,000
- 847 support tickets created
- No data loss or security implications

## Timeline (All times UTC)

| Time  | Event                                           |
| ----- | ----------------------------------------------- |
| 14:23 | Deployment v2.3.4 completed to production       |
| 14:31 | First alert: `payment_error_rate > 5%`          |
| 14:33 | On-call engineer @alice acknowledges alert      |
| 14:35 | Initial investigation begins, error rate at 23% |
| 14:41 | Incident declared SEV2, @bob joins              |
| 14:45 | Database connection exhaustion identified       |
| 14:52 | Decision to rollback deployment                 |
| 14:58 | Rollback to v2.3.3 initiated                    |
| 15:10 | Rollback complete, error rate dropping          |
| 15:18 | Service fully recovered, incident resolved      |

## Root Cause Analysis

### What Happened

The v2.3.4 deployment included a change to the database query pattern that inadvertently removed connection pooling for a frequently-called endpoint. Each request opened a new database connection instead of reusing pooled connections.

### Why It Happened

1. **Proximate Cause**: Code change in `PaymentRepository.java` replaced pooled `DataSource` with direct `DriverManager.getConnection()` calls.

2. **Contributing Factors**:
   - Code review did not catch the connection handling change
   - No integration tests specifically for connection pool behavior
   - Staging environment has lower traffic, masking the issue
   - Database connection metrics alert threshold was too high (90%)

3. **5 Whys Analysis**:
   - Why did the service fail? → Database connections exhausted
   - Why were connections exhausted? → Each request opened new connection
   - Why did each request open new connection? → Code bypassed connection pool
   - Why did code bypass connection pool? → Developer unfamiliar with codebase patterns
   - Why was developer unfamiliar? → No documentation on connection management patterns

### System Diagram
```

[Client] → [Load Balancer] → [Payment Service] → [Database]
↓
Connection Pool (broken)
↓
Direct connections (cause)

```

## Detection

### What Worked
- Error rate alert fired within 8 minutes of deployment
- Grafana dashboard clearly showed connection spike
- On-call response was swift (2 minute acknowledgment)

### What Didn't Work
- Database connection metric alert threshold too high
- No deployment-correlated alerting
- Canary deployment would have caught this earlier

### Detection Gap
The deployment completed at 14:23, but the first alert didn't fire until 14:31 (8 minutes). A deployment-aware alert could have detected the issue faster.

## Response

### What Worked
- On-call engineer quickly identified database as the issue
- Rollback decision was made decisively
- Clear communication in incident channel

### What Could Be Improved
- Took 10 minutes to correlate issue with recent deployment
- Had to manually check deployment history
- Rollback took 12 minutes (could be faster)

## Impact

### Customer Impact
- 12,000 unique customers affected
- Average impact duration: 35 minutes
- 847 support tickets (23% of affected users)
- Customer satisfaction score dropped 12 points

### Business Impact
- Estimated revenue loss: $45,000
- Support cost: ~$2,500 (agent time)
- Engineering time: ~8 person-hours

### Technical Impact
- Database primary experienced elevated load
- Some replica lag during incident
- No permanent damage to systems

## Lessons Learned

### What Went Well
1. Alerting detected the issue before customer reports
2. Team collaborated effectively under pressure
3. Rollback procedure worked smoothly
4. Communication was clear and timely

### What Went Wrong
1. Code review missed critical change
2. Test coverage gap for connection pooling
3. Staging environment doesn't reflect production traffic
4. Alert thresholds were not tuned properly

### Where We Got Lucky
1. Incident occurred during business hours with full team available
2. Database handled the load without failing completely
3. No other incidents occurred simultaneously

## Action Items

| Priority | Action | Owner | Due Date | Ticket |
|----------|--------|-------|----------|--------|
| P0 | Add integration test for connection pool behavior | @alice | 2024-01-22 | ENG-1234 |
| P0 | Lower database connection alert threshold to 70% | @bob | 2024-01-17 | OPS-567 |
| P1 | Document connection management patterns | @alice | 2024-01-29 | DOC-89 |
| P1 | Implement deployment-correlated alerting | @bob | 2024-02-05 | OPS-568 |
| P2 | Evaluate canary deployment strategy | @charlie | 2024-02-15 | ENG-1235 |
| P2 | Load test staging with production-like traffic | @dave | 2024-02-28 | QA-123 |

## Appendix

### Supporting Data

#### Error Rate Graph
[Link to Grafana dashboard snapshot]

#### Database Connection Graph
[Link to metrics]

### Related Incidents
- 2023-11-02: Similar connection issue in User Service (POSTMORTEM-42)

### References
- [Connection Pool Best Practices](internal-wiki/connection-pools)
- [Deployment Runbook](internal-wiki/deployment-runbook)
```

### Template 2: 5 Whys Analysis

```markdown
# 5 Whys Analysis: [Incident]

## Problem Statement

Payment service experienced 47-minute outage due to database connection exhaustion.

## Analysis

### Why #1: Why did the service fail?

**Answer**: Database connections were exhausted, causing all new requests to fail.

**Evidence**: Metrics showed connection count at 100/100 (max), with 500+ pending requests.

---

### Why #2: Why were database connections exhausted?

**Answer**: Each incoming request opened a new database connection instead of using the connection pool.

**Evidence**: Code diff shows direct `DriverManager.getConnection()` instead of pooled `DataSource`.

---

### Why #3: Why did the code bypass the connection pool?

**Answer**: A developer refactored the repository class and inadvertently changed the connection acquisition method.

**Evidence**: PR #1234 shows the change, made while fixing a different bug.

---

### Why #4: Why wasn't this caught in code review?

**Answer**: The reviewer focused on the functional change (the bug fix) and didn't notice the infrastructure change.

**Evidence**: Review comments only discuss business logic.

---

### Why #5: Why isn't there a safety net for this type of change?

**Answer**: We lack automated tests that verify connection pool behavior and lack documentation about our connection patterns.

**Evidence**: Test suite has no tests for connection handling; wiki has no article on database connections.

## Root Causes Identified

1. **Primary**: Missing automated tests for infrastructure behavior
2. **Secondary**: Insufficient documentation of architectural patterns
3. **Tertiary**: Code review checklist doesn't include infrastructure considerations

## Systemic Improvements

| Root Cause    | Improvement                       | Type       |
| ------------- | --------------------------------- | ---------- |
| Missing tests | Add infrastructure behavior tests | Prevention |
| Missing docs  | Document connection patterns      | Prevention |
| Review gaps   | Update review checklist           | Detection  |
| No canary     | Implement canary deployments      | Mitigation |
```

### Template 3: Quick Postmortem (Minor Incidents)

```markdown
# Quick Postmortem: [Brief Title]

**Date**: 2024-01-15 | **Duration**: 12 min | **Severity**: SEV3

## What Happened

API latency spiked to 5s due to cache miss storm after cache flush.

## Timeline

- 10:00 - Cache flush initiated for config update
- 10:02 - Latency alerts fire
- 10:05 - Identified as cache miss storm
- 10:08 - Enabled cache warming
- 10:12 - Latency normalized

## Root Cause

Full cache flush for minor config update caused thundering herd.

## Fix

- Immediate: Enabled cache warming
- Long-term: Implement partial cache invalidation (ENG-999)

## Lessons

Don't full-flush cache in production; use targeted invalidation.
```

## Facilitation Guide

### Running a Postmortem Meeting

```markdown
## Meeting Structure (60 minutes)

### 1. Opening (5 min)

- Remind everyone of blameless culture
- "We're here to learn, not to blame"
- Review meeting norms

### 2. Timeline Review (15 min)

- Walk through events chronologically
- Ask clarifying questions
- Identify gaps in timeline

### 3. Analysis Discussion (20 min)

- What failed?
- Why did it fail?
- What conditions allowed this?
- What would have prevented it?

### 4. Action Items (15 min)

- Brainstorm improvements
- Prioritize by impact and effort
- Assign owners and due dates

### 5. Closing (5 min)

- Summarize key learnings
- Confirm action item owners
- Schedule follow-up if needed

## Facilitation Tips

- Keep discussion on track
- Redirect blame to systems
- Encourage quiet participants
- Document dissenting views
- Time-box tangents
```

## Anti-Patterns to Avoid

| Anti-Pattern            | Problem                    | Better Approach                 |
| ----------------------- | -------------------------- | ------------------------------- |
| **Blame game**          | Shuts down learning        | Focus on systems                |
| **Shallow analysis**    | Doesn't prevent recurrence | Ask "why" 5 times               |
| **No action items**     | Waste of time              | Always have concrete next steps |
| **Unrealistic actions** | Never completed            | Scope to achievable tasks       |
| **No follow-up**        | Actions forgotten          | Track in ticketing system       |

## Best Practices

### Do's

- **Start immediately** - Memory fades fast
- **Be specific** - Exact times, exact errors
- **Include graphs** - Visual evidence
- **Assign owners** - No orphan action items
- **Share widely** - Organizational learning

### Don'ts

- **Don't name and shame** - Ever
- **Don't skip small incidents** - They reveal patterns
- **Don't make it a blame doc** - That kills learning
- **Don't create busywork** - Actions should be meaningful
- **Don't skip follow-up** - Verify actions completed

## Resources

- [Google SRE - Postmortem Culture](https://sre.google/sre-book/postmortem-culture/)
- [Etsy's Blameless Postmortems](https://codeascraft.com/2012/05/22/blameless-postmortems/)
- [PagerDuty Postmortem Guide](https://postmortems.pagerduty.com/)
