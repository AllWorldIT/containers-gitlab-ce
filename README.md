# GitLab Container Images

**WARNING: THIS IS NOT THE OFFICIAL GITLAB CONTAINER IMAGES!**

This distribution of GitLab Docker containers images includes Conarx Extended Storage support which fixes storage backends which GitLab
refuses to accept patches for or support.

A notable case of this is using replicated Minio S3 storage backends.


## Image Differences

Differences between these images and official images are listed below...

* `container-registry` is patched with changes that fixes support for using Minio S3 in a replicated setup with versioning as a container storage backend.


## Compatibility

Our images are fully compatible with GitLab official images.


# Using CES Images

Simply change the image used to `allworldit/gitlab-ce`.

A specific version can be used by using `allworldit/gitlab-ce:15.7.2-ce.0`.



# Support

Commercial support for Conarx Extended Storage is provided by [Conarx](https://conarx.tech).
