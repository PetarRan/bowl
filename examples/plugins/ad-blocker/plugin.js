// Bowl Plugin: Simple Ad Blocker
// Removes common ad elements from pages

(function() {
    'use strict';

    console.log('🛡️ Ad blocker plugin loaded');

    // Common ad selectors
    const adSelectors = [
        '[id*="google_ads"]',
        '[class*="google-ad"]',
        '[class*="advertisement"]',
        '[id*="ad-container"]',
        '[class*="ad-banner"]',
        'iframe[src*="doubleclick.net"]',
        'iframe[src*="googlesyndication.com"]',
        '.ad',
        '.ads',
        '.advert'
    ];

    function removeAds() {
        let removedCount = 0;

        adSelectors.forEach(selector => {
            const elements = document.querySelectorAll(selector);
            elements.forEach(el => {
                el.remove();
                removedCount++;
            });
        });

        if (removedCount > 0) {
            console.log(`🛡️ Blocked ${removedCount} ad elements`);
        }
    }

    // Remove ads on load
    removeAds();

    // Watch for dynamically added ads
    const observer = new MutationObserver(() => {
        removeAds();
    });

    observer.observe(document.body, {
        childList: true,
        subtree: true
    });

    // Clean up styles
    const style = document.createElement('style');
    style.textContent = `
        /* Hide common ad containers */
        [class*="ad-"],
        [id*="ad-"],
        [class*="google-ad"],
        [class*="advertisement"] {
            display: none !important;
        }
    `;
    document.head.appendChild(style);
})();
