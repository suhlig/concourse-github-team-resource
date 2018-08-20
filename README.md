# concourse-github-team-resource

[![Build Status](https://travis-ci.org/suhlig/concourse-github-team-resource.svg?branch=master)](https://travis-ci.org/suhlig/concourse-github-team-resource)

[Concourse](https://concourse-ci.org/ "Concourse Homepage") [resource](https://concourse-ci.org/implementing-resources.html "Implementing a Resource") for GitHub Teams. It fires when a GitHub team was updated.

# Resource Type Configuration

```yaml
resource_types:
  - name: github-team-resource
    type: docker-image
    source:
      repository: suhlig/concourse-github-team-resource
      tag: latest
```

# Source Configuration

* `organization`: *Required* Name of the organization the team belongs to
* `team`: *Required* Name of the team to track
* `access_token`: *Required* the [OAuth access token](http://developer.github.com/v3/oauth/) that should be used for authenticated access to GitHub
* `api_endpoint`: *Optional* API endpoint if different than `https://api.github.com`, e.g. `https://github.example.com/api/v3/`

# Behavior

## `check`: Extract items from the team

The resource will fetch the information about the given `team` that is part of an `organization` and will version items by their `updated_at` attribute.

## `in`: Fetch the team at the given `updated_at` timestamp

The resource will fetch the team at the requested `updated_at` timestamp. For each attribute of the the team, it writes the attribute value to a file into the destination directory. You can then read these files in a task.

## `out`: Not implemented

There is no output from this resource.

# Development

## One-time Setup

```bash
bundle install
```

## Running the Tests

Tests assume you have a running docker daemon:

```bash
bundle exec rake
```

## Docker Image

TODO After a `git push` to the master branch, if the build was successful, Travis [automatically pushes an updated docker image](https://docs.travis-ci.com/user/docker/#Pushing-a-Docker-Image-to-a-Registry).
