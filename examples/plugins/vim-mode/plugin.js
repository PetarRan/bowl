// Bowl Plugin: Vim Mode
// Adds vim-style navigation keybindings

(function() {
    'use strict';

    console.log('🎯 Vim mode plugin loaded');

    // Track if we're in a text input
    let inInput = false;

    document.addEventListener('focusin', (e) => {
        if (e.target.tagName === 'INPUT' ||
            e.target.tagName === 'TEXTAREA' ||
            e.target.isContentEditable) {
            inInput = true;
        }
    });

    document.addEventListener('focusout', () => {
        inInput = false;
    });

    // Vim keybindings
    document.addEventListener('keydown', (e) => {
        // Skip if in input field
        if (inInput) return;

        switch(e.key) {
            case 'j':
                // Scroll down
                window.scrollBy(0, 100);
                e.preventDefault();
                break;

            case 'k':
                // Scroll up
                window.scrollBy(0, -100);
                e.preventDefault();
                break;

            case 'h':
                // Go back
                window.history.back();
                e.preventDefault();
                break;

            case 'l':
                // Go forward
                window.history.forward();
                e.preventDefault();
                break;

            case 'g':
                if (e.shiftKey) {
                    // G - scroll to bottom
                    window.scrollTo(0, document.body.scrollHeight);
                } else {
                    // gg - scroll to top (simplified, needs state)
                    window.scrollTo(0, 0);
                }
                e.preventDefault();
                break;

            case 'r':
                // Reload page
                window.location.reload();
                e.preventDefault();
                break;

            case 't':
                // New tab (using Bowl API)
                if (window.bowl) {
                    window.bowl.newTab();
                }
                e.preventDefault();
                break;
        }
    });

    // Show hint on page load
    if (window.bowl) {
        setTimeout(() => {
            window.bowl.notify('Vim mode active: j/k scroll, h/l nav, r reload, t new tab');
        }, 500);
    }
})();
