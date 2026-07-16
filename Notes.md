# Notes

## Conventions

- Ignorer les dossiers `BUILD/` : ce sont des applications compilées à partir des sources, pas la source de vérité. Les exclure des recherches et des modifications.

## TODO

- [ ] Remplacer les `.PRODUCT` en chargeant les images dans les composants.
- [ ] **4DPop-KeepIt** : revoir/moderniser le code et supprimer les warnings de compilation.
- [ ] **4DPop-XLIFF-Pro** : revoir pour utiliser les classes `ui-with_classes`.

### Fichiers sources référençant `.PRODUCT_RESOURCES/` (hors `BUILD/`)

**4DPop** ✅ fait
- `Project/Sources/Classes/_strip.4dm`
- `Project/Sources/Classes/_widget.4dm`
- `Project/Sources/Forms/STRIP/form.4DForm`

**4DPop-Window** ✅ fait
- `Project/Sources/Classes/_component.4dm`
- `Project/Sources/Classes/menu.4dm`
- `Resources/desc.json`

**4DPop-KeepIt** ✅ fait
- `Project/Sources/Classes/menu.4dm`
- `Resources/desc.json`

**4DPop-Git** ✅ fait
- `Project/Sources/Forms/ALERT/form.4DForm`
- `Project/Sources/Forms/GIT/form.4DForm`
- `Project/Sources/Forms/MESSAGE/form.4DForm`
- `Project/Sources/Forms/WIDGET/form.4DForm`

**4DPop-XLIFF-Pro** ✅ fait
- `Project/Sources/Classes/form.4dm`
- `Project/Sources/Classes/menu.4dm`
- `Project/Sources/Classes/static.4dm`
- `Project/Sources/Forms/EDITOR/form.4DForm`

**4DPop-Bookmarks**
- `Project/Sources/Classes/menu.4dm`

**4DPop-Constants-Editor**
- `Project/Sources/Forms/mess_Confirm/form.4DForm`
- `Project/Sources/Forms/mess_Request/form.4DForm`
