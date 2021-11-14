# Custom Xcode Shortcuts

Inspired by a [superb video](https://www.youtube.com/watch?v=Gw7V2COqiJc) by [CodeSlicing](https://www.youtube.com/channel/UCakreohbcr3Xcrlc6qbbbVA), I've added user defined keyboard shortcuts to Xcode.

Installing to Xcode is a bit of a pain, and needs to be done each time you update Xcode, so that seems like a perfect opportunity to script it.

Custom shortcuts are defined in the key bindings file:

```
/Applications/Xcode.app/Contents/Frameworks/IDEKit.framework/Resources/IDETextKeyBindingSet.plist
```

I often have a production and beta version of Xcode installed at the same time, so rather than manually editing this file I run the following:

```
$ ./install.sh
```

## Definition

You can define custom shortcuts as XML within that `IDETextKeyBindingSet.plist`, or luckily `plutil` allows passing in JSON. To add additional key bindings, edit `UserDefined.json`.

## Assigning key bindings

In Xcode go to Preferences > Key Bindings. These are stored in `~/Library/Developer/Xcode/UserData/KeyBindings`, and reflect the name you have selected in Xcode. By default this is `Default.idekeybindings`.

## Included bindings

| Key Binding  | Function |
| ------------- | ------------- |
| <kbd>cmd</kbd> + <kbd>shift</kbd> + <kbd>D</kbd> | Duplicate Current Lines Down |
| <kbd>opt</kbd> + <kbd>return</kbd> | Insert new line below current line |
| <kbd>opt</kbd> + <kbd>shift</kbd> + <kbd>return</kbd> | Insert new line above current line |

## More info

- [Custom Xcode shortcuts](https://luisobo.wordpress.com/2014/01/13/custom-xcode-shortcuts/)
- [Editing Property Lists with plutil](https://scriptingosx.com/2016/11/editing-property-lists/)

