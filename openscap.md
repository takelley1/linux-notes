## OpenSCAP

Run SCAP scan:
```
oscap xccdf eval \
--fetch-remote-resources \                                            # Download any new definition updates.
--profile xccdf_mil.disa.stig_profile_MAC-3_Sensitive \               # Which profile within the STIG checklist to use.
--results /scap_nfs/scap_$(hostname)_$(date +%Y-%m-%d_%H:%M).xml \    # Filepath to place XML results.
--report /scap_nfs/scap_$(hostname)_$(date +%Y-%m-%d_%H:%M).html \    # Filepath to place HTML-formatted results.
/shares/U_Red_Hat_Enterprise_Linux_7_V2R2_STIG_SCAP_1-2_Benchmark.xml # Filepath of the STIG checklist file.
```

Minimum XCCDF file for importing SCAP results to DISA STIG viewer:
```xml
<?xml version="1.0" encoding="UTF-8.  "?>
<TestResult>
  <rule-result idref="SV-86681r2_rule.  ">
    <result>pass</result>
  </rule-result>
  <rule-result idref="SV-86921r3_rule.  ">
    <result>notchecked</result>
  </rule-result>
  <rule-result idref="SV-86473r3_rule.  ">
    <result>notapplicable</result>
  </rule-result>
  <rule-result idref="SV-86853r3_rule.  ">
    <result>fail</result>
  </rule-result>
</TestResult>
```
