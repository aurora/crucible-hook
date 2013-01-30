/**
 * Crucible hook.
 *
 * @copyright   copyright (c) 2013 by Harald Lapp
 * @author      Harald Lapp <harald@octris.org>
 */
/**/
;(function($) {
    /*
     * Initialization.
     */
    var ns     = 'crucible_hook_119af54d_68dd_4915_b5a6_846aa774feca';  // Namespace for accessing vc methods
    var prefix = '/hook';                                               // URL prefix
    var vc     = {};

    /*
     * VC related stuff.
     */
    vc.vcDiff = function vcDiff(repository, branch, commit) {
        $.ajax({
            'type':     'GET',
            'url':      prefix + '/vctool.php?a=diff&amp;r=' + repository + '&amp;b=' + branch + '&amp;c=' + commit,
            'success':  function(result) {
                console.log(result);
            }
        })
    }

    window[ns] = vc;

    /*
     * Content rewrite to inject links to diff tool for commits.
     */
    function rewrite() {
        $('.article-summary').each(function(i, node) {
            var title = $(node).find('li.article-metadata > span.branch-links > span').attr('title');
            
            if (title.match(/^(.*) in (.*)$/)) {
                // matched branch and repository
                var branch = RegExp.$1;
                var repo   = RegExp.$2;

                // match commit
                var commit_node = $(node).find('li.article-object > span.changeset-link');
                var commit_hash = $(commit_node).text();

                $(commit_node).wrapAll(
                    '<a href="javascript://" onclick="' + ns + '.vcDiff(\'' + repo + '\', \'' + branch + '\', \'' + commit_hash + '\')"></a>'
                );
            }
        });
    }

    /*
     * Setup hooks for XMLHttpRequest.send and XMLHttpRequest.onreadystatechange
     */
    var vec = XMLHttpRequest.prototype.send;
    XMLHttpRequest.prototype.send = function() {
        // i did not get it to work when overwriting onreadystatechange on the fly with a setter.
        // therefore i initialize onreadystatechange with an own callback as soon as send is called 
        // and take care that any overwriting of the property by crucible get's stored in a private 
        // variable.
        var onReadyStateChangeCallback = function() {}

        this.onreadystatechange = function() {
            me.onReadyStateChangeCallback(arguments);

            if (this.readyState == 4 && this.status == 200 && this.getResponseHeader('content-type').match(/^text\/html/)) {
                rewrite();
            }
        }

        Object.defineProperty(this, 'onreadystatechange', {
            get: function() { return onreadystatechange; },
            set: function(cb) {
                onReadyStateChangeCallback = cb;
            }
        });

        // make call to original send method
        vec.apply(this, arguments);
    }

    /*
     * Perform first rewrite as soon DOM is build.
     */
    $(document).ready(function() {
        rewrite();
    });
})(jQuery);
