KUBE_APP=hasura
KUBE_NAMESPACE=
k8s: kustomization.yaml
	export KUBE_APP=$(KUBE_APP) && \
	export KUBE_NAMESPACE=$(KUBE_NAMESPACE) && \
	export IMAGE_NAME=$(PREFIX)/$(IMAGE_NAME) && \
	export IMAGE_VER=$(IMAGE_VER) && \
	export INGRESS_BASE_URL=$(INGRESS_BASE_URL) && \
	kubectl kustomize . | envsubst > kubernetes.yaml
