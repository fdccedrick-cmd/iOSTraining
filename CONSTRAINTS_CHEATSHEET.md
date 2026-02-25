# 🎯 CONSTRAINTS QUICK REFERENCE

## Copy-Paste Values for Interface Builder

### CONTAINER VIEW
```
Constraint 1: Top Space to Content View
  Constant: 8

Constraint 2: Leading Space to Content View
  Constant: 16

Constraint 3: Trailing Space to Content View
  Constant: -16

Constraint 4: Bottom Space to Content View
  Constant: -8
```

### PRODUCT IMAGE VIEW
```
Constraint 1: Leading Space to Container View
  Constant: 12

Constraint 2: Top Space to Container View
  Constant: 12

Constraint 3: Width
  Constant: 80

Constraint 4: Height
  Constant: 80

Constraint 5: Bottom Space to Container View
  Constant: -12
  Relation: Less Than or Equal (≤)
  Priority: 750
```

### LABELS STACK VIEW
```
Constraint 1: Leading Space to Image View
  Constant: 12

Constraint 2: Top Space to Container View
  Constant: 12

Constraint 3: Trailing Space to Container View
  Constant: -12

Constraint 4: Center Y to Container View (Optional)
  Constant: 0
  Priority: 250
```

---

## 📋 OUTLET CONNECTIONS

| UI Element | Outlet Name | Type |
|------------|-------------|------|
| Container View | `containerView` | UIView |
| Image View | `productImageView` | UIImageView |
| Name Label | `productNameLabel` | UILabel |
| Price Label | `productPriceLabel` | UILabel |

---

## 🎨 PROPERTY SETTINGS

### Container View
- Background: System Background Color
- No other settings in IB (shadow set in code)

### Product Image View
- Content Mode: Aspect Fill
- Clip to Bounds: ✓
- Background: System Gray 6 Color

### Product Name Label
- Font: System Semibold 16
- Color: Label
- Lines: 2
- Line Break: Word Wrap

### Product Price Label
- Font: System Bold 18
- Color: System Green
- Lines: 1
- Content Hugging Vertical: 251

### Stack View
- Axis: Vertical
- Alignment: Fill
- Distribution: Fill
- Spacing: 4

---

## ⚡ QUICK SETUP SEQUENCE

1. Delete existing content in XIB
2. Add Container View → Set 4 constraints → Connect outlet
3. Add Image View → Set 5 constraints → Connect outlet
4. Add Stack View → Set 3-4 constraints
5. Add Name Label to Stack → Connect outlet
6. Add Price Label to Stack → Connect outlet
7. Build & Run!

---

## 🔍 VERIFICATION

Run this checklist after setup:

- [ ] 4 outlets connected in Connections Inspector
- [ ] No red/yellow constraint warnings
- [ ] Cell height ~104pt in table view
- [ ] Images display correctly
- [ ] Labels don't overlap
- [ ] Card shows with shadow
- [ ] Price formatted with ₱ symbol
- [ ] Disclosure indicator (→) visible

---

## 💡 PRO TIPS

1. **Pin tool** (bottom-right in IB) is fastest for constraints
2. **Cmd+Shift+L** opens Object Library
3. **Cmd+Opt+1** opens Connections Inspector
4. Select view → **Editor > Resolve Auto Layout Issues > Update Frames** fixes misalignment
5. Hold **Option** while setting constraint to set for all sides at once

Done! ✨
