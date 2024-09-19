# Run Docker Registry

This is created for deploying Docker Registry.

Registry V2 API

|Method|Path|Entity|Description|
|-----|--------|----------|-------------|  
|GET|/v2/|Base|Check that the endpoint implements Docker Registry API V2.|
|GET|/v2/<name>/tags/list|Tags|Fetch the tags under the repository identified by name.某仓库下的tag列表|
|GET|/v2/<name>/manifests/<reference>|Manifest|Fetch the manifest identified by name and reference where reference 可以是镜像 tag 或 digest（要用header里的digest）. A HEAD request can also be issued to this endpoint to obtain resource information without receiving all data.获取某仓库某tag信息清单，带上请求header，可以获得指定信息|
|PUT|/v2/<name>/manifests/<reference>|Manifest|Put the manifest identified by name and reference where reference can be a tag or digest.|
|DELETE|/v2/<name>/manifests/<reference>|Manifest|Delete the manifest identified by name and reference. Note that a manifest can only be deleted by digest.（要用header里的镜像digest）|
|GET|/v2/<name>/blobs/<digest>|Blob|Retrieve the blob from the registry identified by digest. A HEAD request can also be issued to this endpoint to obtain resource information without receiving all data.|
|DELETE|/v2/<name>/blobs/<digest>|Blob|Delete the blob identified by name and digest（要用config–>digest）|
|POST|/v2/<name>/blobs/uploads/|Initiate Blob Upload|Initiate a resumable blob upload. If successful, an upload location will be provided to complete the upload. Optionally, if the digest parameter is present, the request body will be used to complete the upload in a single request.|
|GET|/v2/<name>/blobs/uploads/<uuid>|BlobUpload|Retrieve status of upload identified by uuid. The primary purpose of this endpoint is to resolve the current status of a resumable upload.|
|PATCH|/v2/<name>/blobs/uploads/<uuid>|Blob Upload|	Upload a chunk of data for the specified upload.|
|PUT|/v2/<name>/blobs/uploads/<uuid>|Blob Upload|Complete the upload specified by uuid, optionally appending the body as the final chunk.|
|DELETE|/v2/<name>/blobs/uploads/<uuid>|Blob Upload|Cancel outstanding upload processes, releasing associated resources. If this is not called, the unfinished uploads will eventually timeout.|
|GET|/v2/_catalog|Catalog|Retrieve a sorted, json list of repositories available in the registry.仓库列表|

