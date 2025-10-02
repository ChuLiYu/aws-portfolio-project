# Incident Log - Portfolio Website Deployment

## Incident #001: DNS Resolution Failure
**Date**: October 2, 2025  
**Duration**: ~30 minutes  
**Severity**: High  
**Status**: Resolved  

### Description
Domain `luichu.dev` was not resolving, showing `DNS_PROBE_FINISHED_NXDOMAIN` error in browser.

### Root Cause
CloudFront distribution was missing the custom domain alias configuration.

### Resolution
- Added `luichu.dev` to CloudFront distribution aliases
- Configured DNS CNAME record in Cloudflare
- Waited for DNS propagation

### Impact
- Website completely inaccessible
- No user impact (pre-deployment)

---

## Incident #002: Wrong Content Display
**Date**: October 2, 2025  
**Duration**: ~15 minutes  
**Severity**: Medium  
**Status**: Resolved  

### Description
Website was displaying CHAINY URL shortener instead of portfolio content.

### Root Cause
CloudFront distribution was pointing to wrong S3 bucket (`chainy-prod-web` instead of `aws-portfolio-liyu`).

### Resolution
- Updated CloudFront origin to correct S3 bucket
- Configured S3 bucket for website hosting
- Uploaded correct portfolio files
- Invalidated CloudFront cache

### Impact
- Wrong content displayed
- Branding confusion

---

## Incident #003: 403 Forbidden Errors
**Date**: October 2, 2025  
**Duration**: ~45 minutes  
**Severity**: High  
**Status**: Resolved  

### Description
Website showing blank page with 403 errors for CSS/JS resources in browser console.

### Root Cause
Conflicting S3 permissions - both public access and Origin Access Control (OAC) were enabled simultaneously.

### Resolution
- Removed public S3 bucket policy
- Configured OAC-specific bucket policy
- Enabled public access block
- Invalidated CloudFront cache

### Impact
- Website completely non-functional
- Blank page display
- Console errors

---

## Incident #004: Browser Cache Issues
**Date**: October 2, 2025  
**Duration**: ~10 minutes  
**Severity**: Low  
**Status**: Resolved  

### Description
Browser continued showing 403 errors even after server-side fixes.

### Root Cause
Browser caching old HTML content with incorrect resource references.

### Resolution
- Cleared browser cache
- Used incognito mode for testing
- Provided user instructions for cache clearing

### Impact
- User experience issues
- Confusion during troubleshooting

---

## Summary Statistics
- **Total Incidents**: 4
- **Total Downtime**: ~100 minutes
- **Average Resolution Time**: ~25 minutes
- **Success Rate**: 100%

## Key Learnings
1. Always configure DNS before testing custom domain
2. Verify CloudFront origin configuration matches intended content
3. Use either public S3 access OR OAC, not both
4. Clear browser cache when troubleshooting display issues
5. Test with direct CloudFront URL before custom domain

## Prevention Measures
1. Implement infrastructure as code (CloudFormation)
2. Add monitoring and alerting
3. Create deployment checklist
4. Document all configuration steps
5. Test in staging environment first

---

*Log maintained by: Lui Chu*  
*Last Updated: October 2, 2025*
