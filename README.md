# RepoList

iOS app that lists your Github repositories

To be able to log in after you build this:

- Go to [https://github.com/settings/applications/new](https://github.com/settings/applications/new)
- Register with
	* Application name: `Repo List`
	* Homepage URL: Whatever
	* Authoriation callback URL: `repolist://oauth-callback/github`
- After saving, copy the `Client ID` and `Client Secret` from the resulting page into the file: [Repo List/Secrets.plist](https://github.com/linusnyberg/RepoList/blob/master/Repo%20List/Secrets.plist)
