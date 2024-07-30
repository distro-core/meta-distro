# Error Conditions

*   Repository .repo/manifest appears to not track HEAD

    ```
    $ repo sync
    ================================================================================
    Repo command failed: UpdateManifestError
    ```

    Initialize again to force manifest update

    ```
    $ repo init -u https://github.com/distro-core/distro-manifest.git -b main -m distro-head-scarthgap.xml -\-no-clone-bundle
    repo: reusing existing repo client checkout in /srv/build/distro-core

    Your Name  [Firstname Surname]:
    Your Email [username@users.noreply.github.com]:

    Your identity is: Michael Mitchell <username@users.noreply.github.com>
    is this correct [y/N]? y

    repo has been initialized in /srv/build/distro-core
    $ repo sync
    Fetching: 100% (12/12), done in 9.269s
    repo sync has finished successfully.
    ```
